#!/usr/bin/env swift

// Generates app icon PNGs (light, dark, tinted) at 1024x1024
// replicating exactly the SwiftUI rendering from the app.
// Usage: swift scripts/generate-icon.swift

import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

let iconSize = 1024.0
let scale = iconSize / 430.0

// MARK: - Bead data

enum BeadKind { case small, large, crucifix, medal }

struct Bead { let id: Int; let kind: BeadKind }

func makeRosary() -> [Bead] {
    var beads: [Bead] = []
    var id = 0
    func add(_ k: BeadKind) { beads.append(Bead(id: id, kind: k)); id += 1 }
    add(.crucifix); add(.large); add(.small); add(.small); add(.small); add(.large); add(.medal)
    for d in 1...5 { for _ in 1...10 { add(.small) }; if d < 5 { add(.large) } }
    return beads
}

// MARK: - Layout

func layout(beads: [Bead]) -> ([CGPoint], [(CGPoint, CGPoint)]) {
    let pendantCount = 7
    let loopCount = beads.count - pendantCount
    let cx = iconSize / 2
    let radius = iconSize * 0.28

    // Calculate total pendant length below the medal
    let pendantLength = (26.0 + 18.0 * 3 + 26.0 + 26.0 + 20.0) * scale
    // Center the full rosary (loop + pendant) vertically
    let cy = (iconSize - pendantLength) / 2
    let medalY = cy + radius

    var pos = Array(repeating: CGPoint.zero, count: beads.count)
    pos[6] = CGPoint(x: cx, y: medalY)

    let sGap = 18.0 * scale, lGap = 26.0 * scale
    var py = medalY
    py += lGap; pos[5] = CGPoint(x: cx, y: py)
    py += sGap; pos[4] = CGPoint(x: cx, y: py)
    py += sGap; pos[3] = CGPoint(x: cx, y: py)
    py += sGap; pos[2] = CGPoint(x: cx, y: py)
    py += lGap; pos[1] = CGPoint(x: cx, y: py)
    py += lGap; pos[0] = CGPoint(x: cx, y: py)

    let mW = 2.5, sW = 1.0
    let full = 4.0 * mW + 50.0 * sW + 1.5
    let apu = 2.0 * .pi / full
    var angle = .pi / 2 + 0.75 * apu

    for i in 0..<loopCount {
        let w = beads[pendantCount + i].kind == .large ? mW : sW
        angle += w / 2.0 * apu
        pos[pendantCount + i] = CGPoint(x: cx + radius * cos(angle), y: cy + radius * sin(angle))
        angle += w / 2.0 * apu
    }

    var chains: [(CGPoint, CGPoint)] = []
    for i in stride(from: 6, through: 1, by: -1) { chains.append((pos[i], pos[i - 1])) }
    chains.append((pos[6], pos[pendantCount]))
    for i in pendantCount..<(beads.count - 1) { chains.append((pos[i], pos[i + 1])) }
    chains.append((pos[beads.count - 1], pos[6]))
    return (pos, chains)
}

// MARK: - CG Helpers

func cgColor(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(red: r, green: g, blue: b, alpha: a)
}

let rgb = CGColorSpaceCreateDeviceRGB()

func radialGradient(colors: [CGColor], locations: [CGFloat]) -> CGGradient {
    CGGradient(colorsSpace: rgb, colors: colors as CFArray, locations: locations)!
}

func linearGradient(colors: [CGColor], locations: [CGFloat]) -> CGGradient {
    CGGradient(colorsSpace: rgb, colors: colors as CFArray, locations: locations)!
}

// MARK: - Draw chain segment with gradient (matching ChainView)

func drawChains(_ ctx: CGContext, chains: [(CGPoint, CGPoint)], variant: IconVariant) {
    let lineW = 2.0 * scale
    for (start, end) in chains {
        ctx.saveGState()
        // Create a stroked path as clip region
        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: end)
        let strokedPath = path.copy(strokingWithWidth: lineW, lineCap: .round, lineJoin: .round, miterLimit: 10)
        ctx.addPath(strokedPath)
        ctx.clip()

        let grad: CGGradient
        switch variant {
        case .dark:
            grad = linearGradient(
                colors: [cgColor(0.85, 0.65, 0.13), cgColor(1.0, 0.84, 0.0), cgColor(0.85, 0.65, 0.13)],
                locations: [0, 0.5, 1]
            )
        case .light:
            grad = linearGradient(
                colors: [cgColor(0.70, 0.52, 0.08), cgColor(0.85, 0.68, 0.0), cgColor(0.70, 0.52, 0.08)],
                locations: [0, 0.5, 1]
            )
        case .tinted:
            grad = linearGradient(
                colors: [cgColor(0.50, 0.48, 0.45), cgColor(0.65, 0.62, 0.58), cgColor(0.50, 0.48, 0.45)],
                locations: [0, 0.5, 1]
            )
        }
        ctx.drawLinearGradient(grad, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        ctx.restoreGState()
    }
}

// MARK: - Draw bead (matching BeadView.bead — radial gradient + specular highlight)

func drawSmallOrLargeBead(_ ctx: CGContext, center: CGPoint, diameter: CGFloat, variant: IconVariant) {
    let r = diameter / 2

    // Main radial gradient (center offset to upper-left like SwiftUI center: .init(x: 0.35, y: 0.30))
    let gradCenter = CGPoint(x: center.x - r * 0.30, y: center.y - r * 0.40)

    let mainGrad: CGGradient
    switch variant {
    case .dark, .light:
        mainGrad = radialGradient(
            colors: [cgColor(0.72, 0.16, 0.10), cgColor(0.50, 0.09, 0.06), cgColor(0.30, 0.04, 0.02)],
            locations: [0, 0.5, 1]
        )
    case .tinted:
        mainGrad = radialGradient(
            colors: [cgColor(0.55, 0.50, 0.48), cgColor(0.40, 0.36, 0.34), cgColor(0.25, 0.22, 0.20)],
            locations: [0, 0.5, 1]
        )
    }

    // Shadow
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: 2 * scale), blur: 3 * scale,
                  color: cgColor(0, 0, 0, 0.6))
    ctx.addEllipse(in: CGRect(x: center.x - r, y: center.y - r, width: diameter, height: diameter))
    ctx.clip()
    ctx.drawRadialGradient(mainGrad, startCenter: gradCenter, startRadius: 0,
                           endCenter: center, endRadius: r * 0.6,
                           options: [.drawsAfterEndLocation])
    ctx.restoreGState()

    // Specular highlight (white overlay, matching SwiftUI center: .init(x: 0.30, y: 0.25))
    let specCenter = CGPoint(x: center.x - r * 0.40, y: center.y - r * 0.50)
    let specGrad = radialGradient(
        colors: [cgColor(1, 1, 1, variant == .tinted ? 0.25 : 0.45), cgColor(1, 1, 1, 0)],
        locations: [0, 1]
    )
    ctx.saveGState()
    ctx.addEllipse(in: CGRect(x: center.x - r, y: center.y - r, width: diameter, height: diameter))
    ctx.clip()
    ctx.drawRadialGradient(specGrad, startCenter: specCenter, startRadius: 0,
                           endCenter: specCenter, endRadius: r * 0.35 * 2,
                           options: [.drawsAfterEndLocation])
    ctx.restoreGState()
}

// MARK: - Draw medal (matching BeadView.medal — ellipse with gold gradient + highlight + stroke)

func drawMedal(_ ctx: CGContext, center: CGPoint, variant: IconVariant) {
    let w = 24.0 * scale
    let h = w * 1.25
    let rect = CGRect(x: center.x - w / 2, y: center.y - h / 2, width: w, height: h)
    let gradCenter = CGPoint(x: center.x - w * 0.10, y: center.y - h * 0.15)

    let mainGrad: CGGradient
    let strokeColor: CGColor
    switch variant {
    case .dark, .light:
        mainGrad = radialGradient(
            colors: [cgColor(1.0, 0.88, 0.40), cgColor(0.85, 0.65, 0.13), cgColor(0.60, 0.45, 0.08)],
            locations: [0, 0.5, 1]
        )
        strokeColor = cgColor(0.70, 0.50, 0.10)
    case .tinted:
        mainGrad = radialGradient(
            colors: [cgColor(0.70, 0.67, 0.62), cgColor(0.55, 0.52, 0.48), cgColor(0.40, 0.37, 0.33)],
            locations: [0, 0.5, 1]
        )
        strokeColor = cgColor(0.50, 0.47, 0.43)
    }

    // Shadow
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: 2 * scale), blur: 3 * scale,
                  color: cgColor(0, 0, 0, 0.5))
    ctx.addEllipse(in: rect)
    ctx.clip()
    ctx.drawRadialGradient(mainGrad, startCenter: gradCenter, startRadius: 0,
                           endCenter: center, endRadius: w * 0.6,
                           options: [.drawsAfterEndLocation])
    ctx.restoreGState()

    // Specular highlight
    let specCenter = CGPoint(x: center.x - w * 0.20, y: center.y - h * 0.25)
    let specGrad = radialGradient(
        colors: [cgColor(1, 1, 1, variant == .tinted ? 0.3 : 0.5), cgColor(1, 1, 1, 0)],
        locations: [0, 1]
    )
    ctx.saveGState()
    ctx.addEllipse(in: rect)
    ctx.clip()
    ctx.drawRadialGradient(specGrad, startCenter: specCenter, startRadius: 0,
                           endCenter: specCenter, endRadius: w * 0.3 * 2,
                           options: [.drawsAfterEndLocation])
    ctx.restoreGState()

    // Stroke
    ctx.saveGState()
    ctx.setStrokeColor(strokeColor)
    ctx.setLineWidth(1.2 * scale)
    ctx.addEllipse(in: rect)
    ctx.strokePath()
    ctx.restoreGState()
}

// MARK: - Draw crucifix (matching CrucifixView — two rounded rects with linear gradient)

func drawCrucifix(_ ctx: CGContext, center: CGPoint, variant: IconVariant) {
    let vW = 10.0 * scale    // vertical bar width
    let vH = 40.0 * scale    // vertical bar height
    let hW = 26.0 * scale    // horizontal bar width
    let hH = 8.0 * scale     // horizontal bar height
    let cornerR = 3.0 * scale
    let crossbarOffsetY = -8.0 * scale  // offset from center

    let gradColors: [CGColor]
    switch variant {
    case .dark, .light:
        gradColors = [cgColor(1.0, 0.88, 0.40), cgColor(0.85, 0.65, 0.13), cgColor(0.65, 0.50, 0.10)]
    case .tinted:
        gradColors = [cgColor(0.70, 0.67, 0.62), cgColor(0.55, 0.52, 0.48), cgColor(0.40, 0.37, 0.33)]
    }
    let grad = linearGradient(colors: gradColors, locations: [0, 0.5, 1])

    // Shadow
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: 3 * scale), blur: 4 * scale,
                  color: cgColor(0, 0, 0, 0.5))

    // Vertical bar
    let vRect = CGRect(x: center.x - vW / 2, y: center.y - vH / 2, width: vW, height: vH)
    let vPath = CGPath(roundedRect: vRect, cornerWidth: cornerR, cornerHeight: cornerR, transform: nil)
    ctx.saveGState()
    ctx.addPath(vPath)
    ctx.clip()
    ctx.drawLinearGradient(grad,
                           start: CGPoint(x: vRect.minX, y: center.y),
                           end: CGPoint(x: vRect.maxX, y: center.y),
                           options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
    ctx.restoreGState()

    // Horizontal bar
    let hRect = CGRect(x: center.x - hW / 2, y: center.y + crossbarOffsetY - hH / 2, width: hW, height: hH)
    let hPath = CGPath(roundedRect: hRect, cornerWidth: cornerR, cornerHeight: cornerR, transform: nil)
    ctx.saveGState()
    ctx.addPath(hPath)
    ctx.clip()
    ctx.drawLinearGradient(grad,
                           start: CGPoint(x: hRect.minX, y: center.y),
                           end: CGPoint(x: hRect.maxX, y: center.y),
                           options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
    ctx.restoreGState()

    ctx.restoreGState() // shadow
}

// MARK: - Background (matching RosaryView gradient)

func drawBackground(_ ctx: CGContext, variant: IconVariant) {
    let colors: [CGColor]
    switch variant {
    case .dark:
        colors = [cgColor(0.08, 0.05, 0.11), cgColor(0.12, 0.07, 0.04), cgColor(0.04, 0.04, 0.08)]
    case .light:
        colors = [cgColor(0.95, 0.93, 0.90), cgColor(0.92, 0.90, 0.87), cgColor(0.88, 0.86, 0.83)]
    case .tinted:
        colors = [cgColor(0.10, 0.08, 0.12), cgColor(0.12, 0.10, 0.08), cgColor(0.06, 0.06, 0.10)]
    }
    let grad = linearGradient(colors: colors, locations: [0, 0.5, 1])
    ctx.drawLinearGradient(grad, start: .zero, end: CGPoint(x: iconSize, y: iconSize),
                           options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
}

// MARK: - Full icon

enum IconVariant { case dark, light, tinted }

func drawIcon(_ variant: IconVariant) -> CGContext {
    let ctx = CGContext(
        data: nil, width: Int(iconSize), height: Int(iconSize),
        bitsPerComponent: 8, bytesPerRow: 0, space: rgb,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!
    ctx.translateBy(x: 0, y: iconSize)
    ctx.scaleBy(x: 1, y: -1)

    drawBackground(ctx, variant: variant)

    let beads = makeRosary()
    let (pos, chains) = layout(beads: beads)

    drawChains(ctx, chains: chains, variant: variant)

    for bead in beads {
        let p = pos[bead.id]
        switch bead.kind {
        case .small:
            drawSmallOrLargeBead(ctx, center: p, diameter: 14 * scale, variant: variant)
        case .large:
            drawSmallOrLargeBead(ctx, center: p, diameter: 22 * scale, variant: variant)
        case .medal:
            drawMedal(ctx, center: p, variant: variant)
        case .crucifix:
            drawCrucifix(ctx, center: p, variant: variant)
        }
    }

    return ctx
}

// MARK: - Save PNG

func savePNG(_ ctx: CGContext, to path: String) {
    guard let img = ctx.makeImage(),
          let dest = CGImageDestinationCreateWithURL(
              URL(fileURLWithPath: path) as CFURL, UTType.png.identifier as CFString, 1, nil)
    else { print("Failed: \(path)"); return }
    CGImageDestinationAddImage(dest, img, nil)
    if CGImageDestinationFinalize(dest) { print("Saved: \(path)") }
    else { print("Failed to finalize: \(path)") }
}

// MARK: - Main

let dir = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "rosario/rosario/Assets.xcassets/AppIcon.appiconset"

savePNG(drawIcon(.light), to: "\(dir)/AppIcon.png")
savePNG(drawIcon(.dark), to: "\(dir)/AppIcon-dark.png")
savePNG(drawIcon(.tinted), to: "\(dir)/AppIcon-tinted.png")
