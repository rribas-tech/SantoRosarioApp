import Foundation

// MARK: - Prayer

struct Prayer: Hashable {
    let name: String
    let body: String
}

enum Prayers {
    static let credo = Prayer(
        name: String(localized: "Creio em Deus Pai"),
        body: String(localized: "Creio em Deus Pai todo-poderoso, Criador do céu e da terra; e em Jesus Cristo, seu único Filho, nosso Senhor; que foi concebido pelo poder do Espírito Santo; nasceu da Virgem Maria; padeceu sob Pôncio Pilatos, foi crucificado, morto e sepultado; desceu à mansão dos mortos; ressuscitou ao terceiro dia; subiu aos céus, está sentado à direita de Deus Pai todo-poderoso, de onde há de vir a julgar os vivos e os mortos.\n\nCreio no Espírito Santo, na Santa Igreja Católica, na comunhão dos santos, na remissão dos pecados, na ressurreição da carne, na vida eterna. Amém.")
    )

    static let paterNoster = Prayer(
        name: String(localized: "Pai Nosso"),
        body: String(localized: "Pai Nosso, que estais no céu, santificado seja o Vosso Nome, venha a nós o Vosso Reino, seja feita a Vossa Vontade, assim na terra como no céu.\n\nO pão nosso de cada dia nos dai hoje, perdoai-nos as nossas ofensas, assim como nós perdoamos a quem nos tenha ofendido. E não nos deixeis cair em tentação, mas livrai-nos do mal. Amém.")
    )

    static let aveMaria = Prayer(
        name: String(localized: "Ave Maria"),
        body: String(localized: "Ave Maria, cheia de graça, o Senhor é convosco. Bendita sois Vós entre as mulheres, bendito é o fruto de Vosso ventre, Jesus.\n\nSanta Maria, Mãe de Deus, rogai por nós, pecadores, agora e na hora de nossa morte. Amém.")
    )

    static let gloriaPatri = Prayer(
        name: String(localized: "Glória ao Pai"),
        body: String(localized: "Glória ao Pai, ao Filho e ao Espírito Santo, como era no princípio, agora e sempre. Amém.")
    )

    static let jaculatoriaFatima = Prayer(
        name: String(localized: "Jaculatória de Fátima"),
        body: String(localized: "Óh! Meu Jesus, perdoai-nos, livrai-nos do fogo do inferno, levai as almas todas para o Céu e socorrei principalmente as que mais precisarem.")
    )

    static let gloriaPatriEtFatima = Prayer(
        name: String(localized: "Glória ao Pai e Jaculatória de Fátima"),
        body: "\(gloriaPatri.body)\n\n\(jaculatoriaFatima.body)"
    )

    static let salveRegina = Prayer(
        name: String(localized: "Salve Rainha"),
        body: String(localized: "Salve Rainha, Mãe de Misericórdia, vida, doçura e esperança nossa, salve! A Vós bradamos, os degredados filhos de Eva. A Vós suspiramos, gemendo e chorando neste vale de lágrimas.\n\nEia, pois, Advogada nossa, esses Vossos olhos misericordiosos a nós volvei, e, depois deste desterro, mostrai-nos a Jesus, bendito fruto de Vosso ventre, ó clemente, ó piedosa, ó doce sempre Virgem Maria.\n\nRogai por nós, santa Mãe de Deus,\nPara que sejamos dignos das promessas de Cristo.\nAmém.")
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
        name: String(localized: "Início do Rosário"),
        title: String(localized: "Orações Iniciais"),
        scripture: String(localized: "«Ó Deus, vinde em nosso auxílio; Senhor, socorrei-nos e salvai-nos» (Sl 69/70, 2)."),
        beads: [
            StepBead(.crucifix, Prayers.credo),
            StepBead(.large, Prayers.paterNoster),
            StepBead(.small, Prayers.aveMaria, title: String(localized: "Ave Maria, Filha Bem Amada do Pai Eterno")),
            StepBead(.small, Prayers.aveMaria, title: String(localized: "Ave Maria, Mãe Admirável de Deus Filho")),
            StepBead(.small, Prayers.aveMaria, title: String(localized: "Ave Maria, Esposa Fidelíssima do Divino Espírito Santo")),
            StepBead(.chain, Prayers.gloriaPatri),
        ]
    )

    private static let finale = RosaryStep(
        name: String(localized: "Final do Rosário"),
        title: Prayers.salveRegina.name,
        scripture: Prayers.salveRegina.body
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
            beads: [StepBead(.large, Prayers.paterNoster)]
                + Array(repeating: StepBead(.small, Prayers.aveMaria), count: 10)
                + [StepBead(.chain, Prayers.gloriaPatriEtFatima)]
        )
    }

    // MARK: Joyful — Monday, Saturday

    static let joyful = RosaryMystery(
        weekdays: [2, 7],
        name: String(localized: "Mistérios Gozosos"),
        steps: [
            introduction,
            decade(
                name: String(localized: "Primeiro Mistério Gozoso"),
                title: String(localized: "Anunciação do Anjo a Maria"),
                scripture: String(localized: "«O anjo entrou onde ela estava e disse: \"Ave, cheia de graça, o Senhor é contigo\"» (Lc 1, 28).")
            ),
            decade(
                name: String(localized: "Segundo Mistério Gozoso"),
                title: String(localized: "Visitação de Maria a Isabel"),
                scripture: String(localized: "«Naqueles dias, Maria se levantou e foi apressadamente às montanhas, a uma cidade de Judá. Entrou em casa de Zacarias e saudou Isabel» (Lc 1, 39-40).")
            ),
            decade(
                name: String(localized: "Terceiro Mistério Gozoso"),
                title: String(localized: "Nascimento de Jesus em Belém"),
                scripture: String(localized: "«Ela deu à luz o seu filho primogênito, envolveu-o em faixas e reclinou-o numa manjedoura, porque não havia lugar para eles na hospedaria» (Lc 2, 7).")
            ),
            decade(
                name: String(localized: "Quarto Mistério Gozoso"),
                title: String(localized: "Apresentação de Jesus no Templo"),
                scripture: String(localized: "«Concluídos os dias da purificação, segundo a lei de Moisés, levaram-no a Jerusalém para o apresentar ao Senhor» (Lc 2, 22).")
            ),
            decade(
                name: String(localized: "Quinto Mistério Gozoso"),
                title: String(localized: "Encontro de Jesus no Templo"),
                scripture: String(localized: "«Três dias depois, o acharam no templo, sentado no meio dos doutores, ouvindo-os e interrogando-os» (Lc 2, 46).")
            ),
            finale,
        ]
    )

    // MARK: Sorrowful — Tuesday, Friday

    static let sorrowful = RosaryMystery(
        weekdays: [3, 6],
        name: String(localized: "Mistérios Dolorosos"),
        steps: [
            introduction,
            decade(
                name: String(localized: "Primeiro Mistério Doloroso"),
                title: String(localized: "Agonia de Jesus no Horto"),
                scripture: String(localized: "«Retirou-se Jesus com eles para um lugar chamado Getsêmani e disse-lhes: \"Assentai-vos aqui, enquanto eu vou ali orar\"» (Mt 26, 36).")
            ),
            decade(
                name: String(localized: "Segundo Mistério Doloroso"),
                title: String(localized: "Flagelação de Jesus"),
                scripture: String(localized: "«Então lhes soltou Barrabás; mas a Jesus mandou açoitar, e o entregou para ser crucificado» (Mt 27, 26).")
            ),
            decade(
                name: String(localized: "Terceiro Mistério Doloroso"),
                title: String(localized: "Coroação de Espinhos"),
                scripture: String(localized: "«Depois, trançaram uma coroa de espinhos, meteram-lha na cabeça e puseram-lhe na mão uma vara» (Mt 27, 29).")
            ),
            decade(
                name: String(localized: "Quarto Mistério Doloroso"),
                title: String(localized: "Jesus carregando a cruz no caminho do Calvário"),
                scripture: String(localized: "«Conduziram Jesus ao lugar chamado Gólgota, que quer dizer lugar do crânio» (Mc 15, 22).")
            ),
            decade(
                name: String(localized: "Quinto Mistério Doloroso"),
                title: String(localized: "Crucifixão e morte de Jesus"),
                scripture: String(localized: "«Jesus deu então um grande brado e disse: \"Pai, nas tuas mãos entrego o meu espírito\". E, dizendo isso, expirou» (Lc 23, 46).")
            ),
            finale,
        ]
    )

    // MARK: Glorious — Sunday, Wednesday

    static let glorious = RosaryMystery(
        weekdays: [1, 4],
        name: String(localized: "Mistérios Gloriosos"),
        steps: [
            introduction,
            decade(
                name: String(localized: "Primeiro Mistério Glorioso"),
                title: String(localized: "Ressurreição de Jesus"),
                scripture: String(localized: "«No primeiro dia da semana, muito cedo, dirigiram-se ao sepulcro com os aromas que haviam preparado. Acharam a pedra removida longe da abertura do sepulcro. Entraram, mas não encontraram o corpo do Senhor Jesus. Não sabiam elas o que pensar, quando apareceram em frente delas dois personagens com vestes resplandecentes. Como estivessem amedrontadas e voltassem o rosto para o chão, disseram-lhes eles: \"Por que buscais entre os mortos aquele que está vivo? Não está aqui, mas ressuscitou\"» (Lc 24, 1-6).")
            ),
            decade(
                name: String(localized: "Segundo Mistério Glorioso"),
                title: String(localized: "Ascensão de Jesus ao Céu"),
                scripture: String(localized: "«Depois que o Senhor Jesus lhes falou, foi levado ao céu e está sentado à direita de Deus» (Mc 16, 19).")
            ),
            decade(
                name: String(localized: "Terceiro Mistério Glorioso"),
                title: String(localized: "Vinda do Espírito Santo sobre os Apóstolos"),
                scripture: String(localized: "«Chegando o dia de Pentecostes, estavam todos reunidos no mesmo lugar. De repente, veio do céu um ruído, como se soprasse um vento impetuoso, e encheu toda a casa onde estavam sentados» (At 2, 1-2).")
            ),
            decade(
                name: String(localized: "Quarto Mistério Glorioso"),
                title: String(localized: "Assunção de Maria"),
                scripture: String(localized: "«Por isto, desde agora, me proclamarão bem-aventurada todas as gerações, porque realizou em mim maravilhas aquele que é poderoso e cujo nome é Santo» (Lc 1, 48-49).")
            ),
            decade(
                name: String(localized: "Quinto Mistério Glorioso"),
                title: String(localized: "Coroação de Maria no Céu"),
                scripture: String(localized: "«Apareceu em seguida um grande sinal no céu: uma Mulher revestida do sol, a lua debaixo dos seus pés e na cabeça uma coroa de doze estrelas» (Ap 12, 1).")
            ),
            finale,
        ]
    )

    // MARK: Luminous — Thursday

    static let luminous = RosaryMystery(
        weekdays: [5],
        name: String(localized: "Mistérios Luminosos"),
        steps: [
            introduction,
            decade(
                name: String(localized: "Primeiro Mistério Luminoso"),
                title: String(localized: "Batismo de Jesus no rio Jordão"),
                scripture: String(localized: "«Depois que Jesus foi batizado, saiu logo da água. Eis que os céus se abriram e viu descer sobre ele, em forma de pomba, o Espírito de Deus» (Mt 3, 16).")
            ),
            decade(
                name: String(localized: "Segundo Mistério Luminoso"),
                title: String(localized: "Auto-revelação de Jesus nas Bodas de Caná"),
                scripture: String(localized: "«Disse, então, sua mãe aos serventes: \"Fazei o que ele vos disser\"» (Jo 2, 5).")
            ),
            decade(
                name: String(localized: "Terceiro Mistério Luminoso"),
                title: String(localized: "Anúncio do Reino de Deus"),
                scripture: String(localized: "«Completou-se o tempo e o Reino de Deus está próximo; fazei penitência e crede no Evangelho» (Mc 1, 15).")
            ),
            decade(
                name: String(localized: "Quarto Mistério Luminoso"),
                title: String(localized: "Transfiguração de Jesus"),
                scripture: String(localized: "«Lá se transfigurou na presença deles: seu rosto brilhou como o sol, suas vestes tornaram-se resplandecentes de brancura» (Mt 17, 2).")
            ),
            decade(
                name: String(localized: "Quinto Mistério Luminoso"),
                title: String(localized: "Instituição da Eucaristia"),
                scripture: String(localized: "«Durante a refeição, Jesus tomou o pão, benzeu-o, partiu-o e o deu aos discípulos, dizendo: \"Tomai e comei, isto é meu corpo\"» (Mt 26, 26).")
            ),
            finale,
        ]
    )
}
