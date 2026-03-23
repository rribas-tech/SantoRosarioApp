import Foundation

struct MysteryContent: Identifiable, Hashable {
    let set: MysterySet
    let number: Int
    let title: String
    let scripture: String

    var id: String {
        "\(set.rawValue)-\(number)"
    }

    var headerTitle: String {
        title.components(separatedBy: ":").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? title
    }

    var displayTitle: String {
        let parts = title.components(separatedBy: ":")
        guard parts.count > 1 else { return title }
        return parts.dropFirst().joined(separator: ":").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct FocusContent: Hashable {
    let eyebrow: String
    let title: String
    let heroText: String
}

enum MysterySet: String, Hashable {
    case joyful
    case sorrowful
    case glorious
    case luminous

    var pluralTitle: String {
        switch self {
        case .joyful:
            "Mistérios Gozosos"
        case .sorrowful:
            "Mistérios Dolorosos"
        case .glorious:
            "Mistérios Gloriosos"
        case .luminous:
            "Mistérios Luminosos"
        }
    }

    var mysteries: [MysteryContent] {
        switch self {
        case .joyful:
            [
                MysteryContent(
                    set: self,
                    number: 1,
                    title: "Primeiro Mistério Gozoso: Anunciação do Anjo a Maria",
                    scripture: "«O anjo entrou onde ela estava e disse: \"Ave, cheia de graça, o Senhor é contigo\"» (Lc 1, 28)."
                ),
                MysteryContent(
                    set: self,
                    number: 2,
                    title: "Segundo Mistério Gozoso: Visitação de Maria a Isabel",
                    scripture: "«Naqueles dias, Maria se levantou e foi apressadamente às montanhas, a uma cidade de Judá. Entrou em casa de Zacarias e saudou Isabel» (Lc 1, 39-40)."
                ),
                MysteryContent(
                    set: self,
                    number: 3,
                    title: "Terceiro Mistério Gozoso: Nascimento de Jesus em Belém",
                    scripture: "«Ela deu à luz o seu filho primogênito, envolveu-o em faixas e reclinou-o numa manjedoura, porque não havia lugar para eles na hospedaria» (Lc 2, 7)."
                ),
                MysteryContent(
                    set: self,
                    number: 4,
                    title: "Quarto Mistério Gozoso: Apresentação de Jesus no Templo",
                    scripture: "«Concluídos os dias da purificação, segundo a lei de Moisés, levaram-no a Jerusalém para o apresentar ao Senhor» (Lc 2, 22)."
                ),
                MysteryContent(
                    set: self,
                    number: 5,
                    title: "Quinto Mistério Gozoso: Encontro de Jesus no Templo",
                    scripture: "«Três dias depois, o acharam no templo, sentado no meio dos doutores, ouvindo-os e interrogando-os» (Lc 2, 46)."
                ),
            ]
        case .sorrowful:
            [
                MysteryContent(
                    set: self,
                    number: 1,
                    title: "Primeiro Mistério Doloroso: Agonia de Jesus no Horto",
                    scripture: "«Retirou-se Jesus com eles para um lugar chamado Getsêmani e disse-lhes: \"Assentai-vos aqui, enquanto eu vou ali orar\"» (Mt 26, 36)."
                ),
                MysteryContent(
                    set: self,
                    number: 2,
                    title: "Segundo Mistério Doloroso: Flagelação de Jesus",
                    scripture: "«Então lhes soltou Barrabás; mas a Jesus mandou açoitar, e o entregou para ser crucificado» (Mt 27, 26)."
                ),
                MysteryContent(
                    set: self,
                    number: 3,
                    title: "Terceiro Mistério Doloroso: Coroação de Espinhos",
                    scripture: "«Depois, trançaram uma coroa de espinhos, meteram-lha na cabeça e puseram-lhe na mão uma vara» (Mt 27, 29)."
                ),
                MysteryContent(
                    set: self,
                    number: 4,
                    title: "Quarto Mistério Doloroso: Jesus carregando a cruz no caminho do Calvário",
                    scripture: "«Conduziram Jesus ao lugar chamado Gólgota, que quer dizer lugar do crânio» (Mc 15, 22)."
                ),
                MysteryContent(
                    set: self,
                    number: 5,
                    title: "Quinto Mistério Doloroso: Crucifixão e morte de Jesus",
                    scripture: "«Jesus deu então um grande brado e disse: \"Pai, nas tuas mãos entrego o meu espírito\". E, dizendo isso, expirou» (Lc 23, 46)."
                ),
            ]
        case .glorious:
            [
                MysteryContent(
                    set: self,
                    number: 1,
                    title: "Primeiro Mistério Glorioso: Ressurreição de Jesus",
                    scripture: "«No primeiro dia da semana, muito cedo, dirigiram-se ao sepulcro com os aromas que haviam preparado. Acharam a pedra removida longe da abertura do sepulcro. Entraram, mas não encontraram o corpo do Senhor Jesus. Não sabiam elas o que pensar, quando apareceram em frente delas dois personagens com vestes resplandecentes. Como estivessem amedrontadas e voltassem o rosto para o chão, disseram-lhes eles: \"Por que buscais entre os mortos aquele que está vivo? Não está aqui, mas ressuscitou\"» (Lc 24, 1-6)."
                ),
                MysteryContent(
                    set: self,
                    number: 2,
                    title: "Segundo Mistério Glorioso: Ascensão de Jesus ao Céu",
                    scripture: "«Depois que o Senhor Jesus lhes falou, foi levado ao céu e está sentado à direita de Deus» (Mc 16, 19)."
                ),
                MysteryContent(
                    set: self,
                    number: 3,
                    title: "Terceiro Mistério Glorioso: Vinda do Espírito Santo sobre os Apóstolos",
                    scripture: "«Chegando o dia de Pentecostes, estavam todos reunidos no mesmo lugar. De repente, veio do céu um ruído, como se soprasse um vento impetuoso, e encheu toda a casa onde estavam sentados» (At 2, 1-2)."
                ),
                MysteryContent(
                    set: self,
                    number: 4,
                    title: "Quarto Mistério Glorioso: Assunção de Maria",
                    scripture: "«Por isto, desde agora, me proclamarão bem-aventurada todas as gerações, porque realizou em mim maravilhas aquele que é poderoso e cujo nome é Santo» (Lc 1, 48-49)."
                ),
                MysteryContent(
                    set: self,
                    number: 5,
                    title: "Quinto Mistério Glorioso: Coroação de Maria no Céu",
                    scripture: "«Apareceu em seguida um grande sinal no céu: uma Mulher revestida do sol, a lua debaixo dos seus pés e na cabeça uma coroa de doze estrelas» (Ap 12, 1)."
                ),
            ]
        case .luminous:
            [
                MysteryContent(
                    set: self,
                    number: 1,
                    title: "Primeiro Mistério Luminoso: Batismo de Jesus no rio Jordão",
                    scripture: "«Depois que Jesus foi batizado, saiu logo da água. Eis que os céus se abriram e viu descer sobre ele, em forma de pomba, o Espírito de Deus» (Mt 3, 16)."
                ),
                MysteryContent(
                    set: self,
                    number: 2,
                    title: "Segundo Mistério Luminoso: Auto-revelação de Jesus nas Bodas de Caná",
                    scripture: "«Disse, então, sua mãe aos serventes: \"Fazei o que ele vos disser\"» (Jo 2, 5)."
                ),
                MysteryContent(
                    set: self,
                    number: 3,
                    title: "Terceiro Mistério Luminoso: Anúncio do Reino de Deus",
                    scripture: "«Completou-se o tempo e o Reino de Deus está próximo; fazei penitência e crede no Evangelho» (Mc 1, 15)."
                ),
                MysteryContent(
                    set: self,
                    number: 4,
                    title: "Quarto Mistério Luminoso: Transfiguração de Jesus",
                    scripture: "«Lá se transfigurou na presença deles: seu rosto brilhou como o sol, suas vestes tornaram-se resplandecentes de brancura» (Mt 17, 2)."
                ),
                MysteryContent(
                    set: self,
                    number: 5,
                    title: "Quinto Mistério Luminoso: Instituição da Eucaristia",
                    scripture: "«Durante a refeição, Jesus tomou o pão, benzeu-o, partiu-o e o deu aos discípulos, dizendo: \"Tomai e comei, isto é meu corpo\"» (Mt 26, 26)."
                ),
            ]
        }
    }

    static func forDate(_ date: Date = .now, calendar: Calendar = .current) -> MysterySet {
        switch calendar.component(.weekday, from: date) {
        case 1:
            .glorious
        case 2:
            .joyful
        case 3:
            .sorrowful
        case 4:
            .glorious
        case 5:
            .luminous
        case 6:
            .sorrowful
        default:
            .joyful
        }
    }
}

enum RosaryFocusSection: Hashable {
    case introduction
    case mystery(Int)
    case finale

    static let orderedSections: [RosaryFocusSection] = [
        .introduction,
        .mystery(0),
        .mystery(1),
        .mystery(2),
        .mystery(3),
        .mystery(4),
        .finale,
    ]

    var beadIDs: [Int] {
        switch self {
        case .introduction:
            [0, 1, 2, 3, 4]
        case .mystery(let index):
            switch index {
            case 0:
                [5] + Array(7...16)
            case 1:
                [17] + Array(18...27)
            case 2:
                [28] + Array(29...38)
            case 3:
                [39] + Array(40...49)
            default:
                [50] + Array(51...60)
            }
        case .finale:
            [6]
        }
    }

    var stripTitle: String {
        switch self {
        case .introduction:
            "Contas iniciais"
        case .mystery:
            "Contas deste mistério"
        case .finale:
            "Encerramento"
        }
    }

    var progressTitle: String {
        switch self {
        case .introduction:
            "Início do Rosário"
        case .mystery(let index):
            "Mistério \(index + 1) de 5"
        case .finale:
            "Final do Rosário"
        }
    }

    var defaultBeadID: Int {
        beadIDs.first ?? 0
    }

    func content(for mysterySet: MysterySet) -> FocusContent {
        switch self {
        case .introduction:
            return FocusContent(
                eyebrow: "Início do Rosário",
                title: "Orações iniciais",
                heroText: "Em nome do Pai, do Filho e do Espírito Santo.\n\n«Ó Deus, vinde em nosso auxílio; Senhor, socorrei-nos e salvai-nos» (Sl 69/70, 2).\n\nGlória ao Pai, ao Filho e ao Espírito Santo.\nComo era no princípio, agora e sempre,\nAmém."
            )
        case .mystery(let index):
            let mystery = mysterySet.mysteries[index]
            return FocusContent(
                eyebrow: mystery.headerTitle,
                title: mystery.displayTitle,
                heroText: mystery.scripture
            )
        case .finale:
            return FocusContent(
                eyebrow: "Final do Rosário",
                title: "Salve Rainha",
                heroText: "Salve Rainha, Mãe de Misericórdia, vida, doçura e esperança nossa, salve! A Vós bradamos, os degredados filhos de Eva. A Vós suspiramos, gemendo e chorando neste vale de lágrimas.\n\nEia, pois, Advogada nossa, esses Vossos olhos misericordiosos a nós volvei, e, depois deste desterro, mostrai-nos a Jesus, bendito fruto de Vosso ventre, ó clemente, ó piedosa, ó doce sempre Virgem Maria.\n\nRogai por nós, santa Mãe de Deus,\nPara que sejamos dignos das promessas de Cristo.\nAmém."
            )
        }
    }

    static func from(beadID: Int) -> RosaryFocusSection {
        switch beadID {
        case 0...4:
            .introduction
        case 6:
            .finale
        case 5, 7...16:
            .mystery(0)
        case 17...27:
            .mystery(1)
        case 28...38:
            .mystery(2)
        case 39...49:
            .mystery(3)
        default:
            .mystery(4)
        }
    }
}

struct RosaryFocusContext: Hashable {
    let mysterySet: MysterySet
    let section: RosaryFocusSection
    let selectedBeadID: Int
}
