import Foundation

// MARK: - Prayer

struct Prayer: Hashable {
    let name: String
    let body: String
}

enum Prayers {
    static let creed = Prayer(
        name: "Creio em Deus Pai",
        body: "Creio em Deus Pai todo-poderoso, Criador do céu e da terra; e em Jesus Cristo, seu único Filho, nosso Senhor; que foi concebido pelo poder do Espírito Santo; nasceu da Virgem Maria; padeceu sob Pôncio Pilatos, foi crucificado, morto e sepultado; desceu à mansão dos mortos; ressuscitou ao terceiro dia; subiu aos céus, está sentado à direita de Deus Pai todo-poderoso, de onde há de vir a julgar os vivos e os mortos.\n\nCreio no Espírito Santo, na Santa Igreja Católica, na comunhão dos santos, na remissão dos pecados, na ressurreição da carne, na vida eterna. Amém."
    )

    static let ourFather = Prayer(
        name: "Pai Nosso",
        body: "Pai Nosso, que estais no céu, santificado seja o Vosso Nome, venha a nós o Vosso Reino, seja feita a Vossa Vontade, assim na terra como no céu.\n\nO pão nosso de cada dia nos dai hoje, perdoai-nos as nossas ofensas, assim como nós perdoamos a quem nos tenha ofendido. E não nos deixeis cair em tentação, mas livrai-nos do mal. Amém."
    )

    static let hailMary = Prayer(
        name: "Ave Maria",
        body: "Ave Maria, cheia de graça, o Senhor é convosco. Bendita sois Vós entre as mulheres, bendito é o fruto de Vosso ventre, Jesus.\n\nSanta Maria, Mãe de Deus, rogai por nós, pecadores, agora e na hora de nossa morte. Amém."
    )

    static let gloryBe = Prayer(
        name: "Glória ao Pai",
        body: "Glória ao Pai, ao Filho e ao Espírito Santo, como era no princípio, agora e sempre. Amém."
    )

    static let fatima = Prayer(
        name: "Jaculatória de Fátima",
        body: "Óh! Meu Jesus, perdoai-nos, livrai-nos do fogo do inferno, levai as almas todas para o Céu e socorrei principalmente as que mais precisarem."
    )

    static let gloryBeWithFatima = Prayer(
        name: "\(gloryBe.name) e \(fatima.name)",
        body: "\(gloryBe.body)\n\n\(fatima.body)"
    )

    static let salveRainha = Prayer(
        name: "Salve Rainha",
        body: "Salve Rainha, Mãe de Misericórdia, vida, doçura e esperança nossa, salve! A Vós bradamos, os degredados filhos de Eva. A Vós suspiramos, gemendo e chorando neste vale de lágrimas.\n\nEia, pois, Advogada nossa, esses Vossos olhos misericordiosos a nós volvei, e, depois deste desterro, mostrai-nos a Jesus, bendito fruto de Vosso ventre, ó clemente, ó piedosa, ó doce sempre Virgem Maria.\n\nRogai por nós, santa Mãe de Deus,\nPara que sejamos dignos das promessas de Cristo.\nAmém."
    )
}

// MARK: - Data Types

enum BeadIcon: Hashable {
    case crucifix
    case large
    case small
    case medal
    case chain
}

struct StepBead: Hashable {
    let icon: BeadIcon
    let prayer: Prayer
    let title: String?

    init(_ icon: BeadIcon, _ prayer: Prayer, title: String? = nil) {
        self.icon = icon
        self.prayer = prayer
        self.title = title
    }

    var displayTitle: String { title ?? prayer.name }
}

struct RosaryStep: Identifiable, Hashable {
    let name: String
    let title: String
    let scripture: String
    let beads: [StepBead]

    var id: String { name }

    init(name: String, title: String, scripture: String, beads: [StepBead] = []) {
        self.name = name
        self.title = title
        self.scripture = scripture
        self.beads = beads
    }
}

struct RosaryMystery: Identifiable, Hashable {
    let weekdays: [Int]
    let name: String
    let steps: [RosaryStep]

    var id: String { name }
}

// MARK: - Navigation Context

struct RosaryFocusContext: Hashable {
    let mystery: RosaryMystery
    let stepIndex: Int
    let beadIndex: Int
}

// MARK: - Physical Bead Mapping

extension RosaryCatalog {
    static func stepPosition(forPhysicalBead beadID: Int) -> (stepIndex: Int, beadIndex: Int) {
        if beadID <= 4 { return (0, beadID) }
        if beadID == 5 { return (1, 0) }
        if beadID == 6 { return (6, 0) }
        if beadID <= 16 { return (1, beadID - 6) }
        let offset = beadID - 17
        return (offset / 11 + 2, offset % 11)
    }
}

// MARK: - Catalog

enum RosaryCatalog {
    static let all: [RosaryMystery] = [joyful, sorrowful, glorious, luminous]

    static func forDate(_ date: Date = .now, calendar: Calendar = .current) -> RosaryMystery {
        let weekday = calendar.component(.weekday, from: date)
        return all.first { $0.weekdays.contains(weekday) } ?? joyful
    }

    // MARK: Shared Steps

    private static let introduction = RosaryStep(
        name: "Início do Rosário",
        title: "Orações Iniciais",
        scripture: "«Ó Deus, vinde em nosso auxílio; Senhor, socorrei-nos e salvai-nos» (Sl 69/70, 2).",
        beads: [
            StepBead(.crucifix, Prayers.creed),
            StepBead(.large, Prayers.ourFather),
            StepBead(.small, Prayers.hailMary, title: "Ave Maria, Filha Bem Amada do Pai Eterno"),
            StepBead(.small, Prayers.hailMary, title: "Ave Maria, Mãe Admirável de Deus Filho"),
            StepBead(.small, Prayers.hailMary, title: "Ave Maria, Esposa Fidelíssima do Divino Espírito Santo"),
            StepBead(.chain, Prayers.gloryBe),
        ]
    )

    private static let finale = RosaryStep(
        name: "Final do Rosário",
        title: Prayers.salveRainha.name,
        scripture: Prayers.salveRainha.body
    )

    private static func decade(
        name: String,
        title: String,
        scripture: String
    ) -> RosaryStep {
        RosaryStep(
            name: name,
            title: title,
            scripture: scripture,
            beads: [StepBead(.large, Prayers.ourFather)]
                + Array(repeating: StepBead(.small, Prayers.hailMary), count: 10)
                + [StepBead(.chain, Prayers.gloryBeWithFatima)]
        )
    }

    // MARK: Joyful — Monday, Saturday

    static let joyful = RosaryMystery(
        weekdays: [2, 7],
        name: "Mistérios Gozosos",
        steps: [
            introduction,
            decade(
                name: "Primeiro Mistério Gozoso",
                title: "Anunciação do Anjo a Maria",
                scripture: "«O anjo entrou onde ela estava e disse: \"Ave, cheia de graça, o Senhor é contigo\"» (Lc 1, 28)."
            ),
            decade(
                name: "Segundo Mistério Gozoso",
                title: "Visitação de Maria a Isabel",
                scripture: "«Naqueles dias, Maria se levantou e foi apressadamente às montanhas, a uma cidade de Judá. Entrou em casa de Zacarias e saudou Isabel» (Lc 1, 39-40)."
            ),
            decade(
                name: "Terceiro Mistério Gozoso",
                title: "Nascimento de Jesus em Belém",
                scripture: "«Ela deu à luz o seu filho primogênito, envolveu-o em faixas e reclinou-o numa manjedoura, porque não havia lugar para eles na hospedaria» (Lc 2, 7)."
            ),
            decade(
                name: "Quarto Mistério Gozoso",
                title: "Apresentação de Jesus no Templo",
                scripture: "«Concluídos os dias da purificação, segundo a lei de Moisés, levaram-no a Jerusalém para o apresentar ao Senhor» (Lc 2, 22)."
            ),
            decade(
                name: "Quinto Mistério Gozoso",
                title: "Encontro de Jesus no Templo",
                scripture: "«Três dias depois, o acharam no templo, sentado no meio dos doutores, ouvindo-os e interrogando-os» (Lc 2, 46)."
            ),
            finale,
        ]
    )

    // MARK: Sorrowful — Tuesday, Friday

    static let sorrowful = RosaryMystery(
        weekdays: [3, 6],
        name: "Mistérios Dolorosos",
        steps: [
            introduction,
            decade(
                name: "Primeiro Mistério Doloroso",
                title: "Agonia de Jesus no Horto",
                scripture: "«Retirou-se Jesus com eles para um lugar chamado Getsêmani e disse-lhes: \"Assentai-vos aqui, enquanto eu vou ali orar\"» (Mt 26, 36)."
            ),
            decade(
                name: "Segundo Mistério Doloroso",
                title: "Flagelação de Jesus",
                scripture: "«Então lhes soltou Barrabás; mas a Jesus mandou açoitar, e o entregou para ser crucificado» (Mt 27, 26)."
            ),
            decade(
                name: "Terceiro Mistério Doloroso",
                title: "Coroação de Espinhos",
                scripture: "«Depois, trançaram uma coroa de espinhos, meteram-lha na cabeça e puseram-lhe na mão uma vara» (Mt 27, 29)."
            ),
            decade(
                name: "Quarto Mistério Doloroso",
                title: "Jesus carregando a cruz no caminho do Calvário",
                scripture: "«Conduziram Jesus ao lugar chamado Gólgota, que quer dizer lugar do crânio» (Mc 15, 22)."
            ),
            decade(
                name: "Quinto Mistério Doloroso",
                title: "Crucifixão e morte de Jesus",
                scripture: "«Jesus deu então um grande brado e disse: \"Pai, nas tuas mãos entrego o meu espírito\". E, dizendo isso, expirou» (Lc 23, 46)."
            ),
            finale,
        ]
    )

    // MARK: Glorious — Sunday, Wednesday

    static let glorious = RosaryMystery(
        weekdays: [1, 4],
        name: "Mistérios Gloriosos",
        steps: [
            introduction,
            decade(
                name: "Primeiro Mistério Glorioso",
                title: "Ressurreição de Jesus",
                scripture: "«No primeiro dia da semana, muito cedo, dirigiram-se ao sepulcro com os aromas que haviam preparado. Acharam a pedra removida longe da abertura do sepulcro. Entraram, mas não encontraram o corpo do Senhor Jesus. Não sabiam elas o que pensar, quando apareceram em frente delas dois personagens com vestes resplandecentes. Como estivessem amedrontadas e voltassem o rosto para o chão, disseram-lhes eles: \"Por que buscais entre os mortos aquele que está vivo? Não está aqui, mas ressuscitou\"» (Lc 24, 1-6)."
            ),
            decade(
                name: "Segundo Mistério Glorioso",
                title: "Ascensão de Jesus ao Céu",
                scripture: "«Depois que o Senhor Jesus lhes falou, foi levado ao céu e está sentado à direita de Deus» (Mc 16, 19)."
            ),
            decade(
                name: "Terceiro Mistério Glorioso",
                title: "Vinda do Espírito Santo sobre os Apóstolos",
                scripture: "«Chegando o dia de Pentecostes, estavam todos reunidos no mesmo lugar. De repente, veio do céu um ruído, como se soprasse um vento impetuoso, e encheu toda a casa onde estavam sentados» (At 2, 1-2)."
            ),
            decade(
                name: "Quarto Mistério Glorioso",
                title: "Assunção de Maria",
                scripture: "«Por isto, desde agora, me proclamarão bem-aventurada todas as gerações, porque realizou em mim maravilhas aquele que é poderoso e cujo nome é Santo» (Lc 1, 48-49)."
            ),
            decade(
                name: "Quinto Mistério Glorioso",
                title: "Coroação de Maria no Céu",
                scripture: "«Apareceu em seguida um grande sinal no céu: uma Mulher revestida do sol, a lua debaixo dos seus pés e na cabeça uma coroa de doze estrelas» (Ap 12, 1)."
            ),
            finale,
        ]
    )

    // MARK: Luminous — Thursday

    static let luminous = RosaryMystery(
        weekdays: [5],
        name: "Mistérios Luminosos",
        steps: [
            introduction,
            decade(
                name: "Primeiro Mistério Luminoso",
                title: "Batismo de Jesus no rio Jordão",
                scripture: "«Depois que Jesus foi batizado, saiu logo da água. Eis que os céus se abriram e viu descer sobre ele, em forma de pomba, o Espírito de Deus» (Mt 3, 16)."
            ),
            decade(
                name: "Segundo Mistério Luminoso",
                title: "Auto-revelação de Jesus nas Bodas de Caná",
                scripture: "«Disse, então, sua mãe aos serventes: \"Fazei o que ele vos disser\"» (Jo 2, 5)."
            ),
            decade(
                name: "Terceiro Mistério Luminoso",
                title: "Anúncio do Reino de Deus",
                scripture: "«Completou-se o tempo e o Reino de Deus está próximo; fazei penitência e crede no Evangelho» (Mc 1, 15)."
            ),
            decade(
                name: "Quarto Mistério Luminoso",
                title: "Transfiguração de Jesus",
                scripture: "«Lá se transfigurou na presença deles: seu rosto brilhou como o sol, suas vestes tornaram-se resplandecentes de brancura» (Mt 17, 2)."
            ),
            decade(
                name: "Quinto Mistério Luminoso",
                title: "Instituição da Eucaristia",
                scripture: "«Durante a refeição, Jesus tomou o pão, benzeu-o, partiu-o e o deu aos discípulos, dizendo: \"Tomai e comei, isto é meu corpo\"» (Mt 26, 26)."
            ),
            finale,
        ]
    )
}
