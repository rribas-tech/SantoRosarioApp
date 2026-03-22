import SwiftUI
import SpriteKit

struct RosaryView: View {
    @State private var state = RosaryState()
    @State private var scene: RosaryScene?

    var body: some View {
        GeometryReader { proxy in
            if let scene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .onChange(of: proxy.size) { _, newSize in
                        scene.size = newSize
                    }
            } else {
                Color(red: 0.04, green: 0.04, blue: 0.08)
                    .ignoresSafeArea()
                    .onAppear {
                        scene = RosaryScene(state: state, size: proxy.size)
                    }
            }
        }
    }
}

#Preview {
    RosaryView()
}
