import Foundation

enum PrayerKind: String, CaseIterable, Identifiable {
    case signOfCross = "Em nome do Pai"
    case apostlesCreed = "Credo"
    case ourFather = "Pai-Nosso"
    case hailMary = "Ave-Maria"
    case gloryBe = "Glória"
    case hailHolyQueen = "Salve Rainha"

    var id: String { rawValue }

    var title: String {
        rawValue
    }

    var prayerText: String {
        switch self {
            case .signOfCross:
                return "Em nome do Pai, do Filho e do Espírito Santo. Amém."

            case .apostlesCreed:
                return "Creio em Deus Pai todo-poderoso, criador do céu e da terra; e em Jesus Cristo, seu único Filho, nosso Senhor; que foi concebido pelo poder do Espírito Santo; nasceu da Virgem Maria; padeceu sob Pôncio Pilatos, foi crucificado, morto e sepultado; desceu à mansão dos mortos; ressuscitou ao terceiro dia; subiu aos céus; está sentado à direita de Deus Pai todo-poderoso, donde há de vir a julgar os vivos e os mortos. Creio no Espírito Santo, na santa Igreja Católica, na comunhão dos santos, na remissão dos pecados, na ressurreição da carne e na vida eterna. Amém."

            case .ourFather:
                return "Pai nosso, que estais nos céus, santificado seja o vosso nome; venha a nós o vosso reino; seja feita a vossa vontade, assim na terra como no céu. O pão nosso de cada dia nos dai hoje; perdoai-nos as nossas ofensas, assim como nós perdoamos a quem nos tem ofendido; e não nos deixeis cair em tentação, mas livrai-nos do mal. Amém."

            case .hailMary:
                return "Ave Maria, cheia de graça, o Senhor é convosco; bendita sois vós entre as mulheres e bendito é o fruto do vosso ventre, Jesus. Santa Maria, Mãe de Deus, rogai por nós, pecadores, agora e na hora de nossa morte. Amém."

            case .gloryBe:
                return "Glória ao Pai, ao Filho e ao Espírito Santo. Como era no princípio, agora e sempre. Amém."

            case .hailHolyQueen:
                return "Salve Rainha, Mãe de misericórdia, vida, doçura e esperança nossa, salve. A vós bradamos, os degredados filhos de Eva; a vós suspiramos, gemendo e chorando neste vale de lágrimas. Eia, pois, advogada nossa, esses vossos olhos misericordiosos a nós volvei; e depois deste desterro mostrai-nos Jesus, bendito fruto do vosso ventre. Ó clemente, ó piedosa, ó doce sempre Virgem Maria. Rogai por nós, santa Mãe de Deus, para que sejamos dignos das promessas de Cristo. Amém."
        }
    }
}

struct RosaryStep: Identifiable, Equatable {
    let id: Int
    let prayer: PrayerKind
    let label: String
}
