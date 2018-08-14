enum InflectError: Error {
    case unknownClassicalModeError
    case badNumValueError
    case badChunkingOptionError
    case numOutOfRangeError
    case badUserDefinedPatternError
    case badRcFileError
    case badGenderError
}

class Inflect {
}

enum Constants {
    
    private static func updateKeys(dict: [String: String]) -> [String: String] {
        var result = dict
        let keys = dict.keys
        
        for key in keys {
            if key.contains("|") {
                let key1key2 = key.split(separator: "|")
                result[String(key1key2[0])] = key
                result[String(key1key2[1])] = key
                result.removeValue(forKey: key)
            }
        }
        
        return result
    }
    
    private static func joinStem(cutPoint: Int = 0, words: [String]) -> String {
        let cuttedString = words.map { String($0.dropLast(cutPoint)) }
        return "(?:\(cuttedString.joined(separator: "|")))"
    }
    
    private static func sortBySize(_ words: [String]) -> [Int: Set<String>] {
        var dict = [Int: Set<String>]()
        
        for word in words {
            if dict[word.count] != nil {
                dict[word.count]?.insert(word)
            } else {
                dict[word.count] = Set([word])
            }
        }
        
        return dict
    }
    
    private static func makePlSiLists(_ lst: [String], plending: String, siendingSize: Int, doJoinStem: Bool = true) -> ([String], [Int: Set<String>], [Int: Set<String>], String?) {
        let cuttedString = lst.map { String($0.dropLast(siendingSize)) }
        let siList = cuttedString.map { $0 + plending }
        let piBySize = sortBySize(lst)
        let siBySize = sortBySize(siList)
        
        if doJoinStem {
            let stem = joinStem(cutPoint: siendingSize, words: lst)
            return (siList, siBySize, piBySize, stem)
        } else {
            return (siList, siBySize, piBySize, nil)
        }
    }
    
    
    // 1. PLURALS
    static let plSbIrregular = [
        "child":      "children",
        "brother":    "brothers|brethren",
        "loaf":       "loaves",
        "hoof":       "hoofs|hooves",
        "beef":       "beefs|beeves",
        "thief":      "thiefs|thieves",
        "money":      "monies",
        "mongoose":   "mongooses",
        "ox":         "oxen",
        "cow":        "cows|kine",
        "graffito":   "graffiti",
        "octopus":    "octopuses|octopodes",
        "genie":      "genies|genii",
        "ganglion":   "ganglions|ganglia",
        "trilby":     "trilbys",
        "turf":       "turfs|turves",
        "numen":      "numina",
        "atman":      "atmas",
        "occiput":    "occiputs|occipita",
        "sabretooth": "sabretooths",
        "sabertooth": "sabertooths",
        "lowlife":    "lowlifes",
        "flatfoot":   "flatfoots",
        "tenderfoot": "tenderfoots",
        "romany":     "romanies",
        "jerry":      "jerries",
        "mary":       "maries",
        "talouse":    "talouses",
        "blouse":     "blouses",
        "rom":        "roma",
        "carmen":     "carmina",
        
        // pl_sb_irregular_s
        "corpus": "corpuses|corpora",
        "opus":   "opuses|opera",
        "genus":  "genera",
        "mythos": "mythoi",
        "penis":  "penises|penes",
        "testis": "testes",
        "atlas":  "atlases|atlantes",
        "yes":    "yeses"
    ]
    
    static var siSbIrregular = updateKeys(dict: Dictionary(uniqueKeysWithValues: Constants.plSbIrregular.map { ($1, $0) }))
    
    static let plSbIrregularCaps = [
        "Romany": "Romanies",
        "Jerry":  "Jerrys",
        "Mary":   "Marys",
        "Rom":    "Roma"
    ]
    
    static let siSbIrregularCaps = Dictionary(uniqueKeysWithValues: Constants.plSbIrregularCaps.map { ($1, $0) })
    
    static let plSbIrregularCompound = [
        "prima donna": "prima donnas|prime donne"
    ]
    
    static let siSbIrregularCompound = updateKeys(dict: Dictionary(uniqueKeysWithValues: Constants.plSbIrregularCompound.map { ($1, $0) }))
    
    // Z's that don't double
    static let plSbZZesList = [
        "quartz", "topaz"
    ]
    
    static let plSbZZesBySize = sortBySize(Constants.plSbZZesList)
    
    static let plSbZeZesList = [
        "snooze"
    ]
    
    static let plSbZeZesBySize = sortBySize(Constants.plSbZeZesList)
    
    // CLASSICAL "..is" -> "..ides"
    static let plSbCIsIdesComplete = [
        // GENERAL WORDS...
        "ephemeris", "iris", "clitoris",
        "chrysalis", "epididymis"
    ]
    
    static let plSbCIsIdesEndings = [
        // INFLAMATIONS...
        "itis"
    ]
    
    static let plSbCIsIdes = joinStem(cutPoint: 2, words: Constants.plSbCIsIdesComplete.appending(contentsOf: Constants.plSbCIsIdesEndings.map { ".*\($0)" }))
    
    static let plSbCIsIdesListTemp = Constants.plSbCIsIdesComplete.appending(contentsOf: Constants.plSbCIsIdesEndings)
    
    private static let siSbCIsIdesListTuple = makePlSiLists(Constants.plSbCIsIdesListTemp, plending: "ides", siendingSize: 2, doJoinStem: false)
    
    static let siSbCIsIdesList = siSbCIsIdesListTuple.0
    static let siSbCIsIdesBysize = siSbCIsIdesListTuple.1
    static let plSbCIsIdesBysize = siSbCIsIdesListTuple.2
    
    // CLASSICAL "..a" -> "..ata"
    static let plSbCAAtaList = [
        "anathema", "bema", "carcinoma", "charisma", "diploma",
        "dogma", "drama", "edema", "enema", "enigma", "lemma",
        "lymphoma", "magma", "melisma", "miasma", "oedema",
        "sarcoma", "schema", "soma", "stigma", "stoma", "trauma",
        "gumma", "pragma"
    ]
    
    private static let plSbCAAtaListTuple = makePlSiLists(Constants.plSbCAAtaList, plending: "ata", siendingSize: 1)
    static let siSbCAAtaList = Constants.plSbCAAtaListTuple.0
    static let siSbCAAtaBysize = Constants.plSbCAAtaListTuple.1
    static let plSbCAAtaBysize = Constants.plSbCAAtaListTuple.2
    static let plSbCAAta  = Constants.plSbCAAtaListTuple.3!
    
    // UNCONDITIONAL "..a" -> "..ae"
    static let plSbUAAeListTemp = [
        "alumna", "alga", "vertebra", "persona"
    ]
    
    private static let plSbUAAeListTuple = makePlSiLists(Constants.plSbUAAeListTemp, plending: "e", siendingSize: 0)
    static let siSbUAAeList = Constants.plSbUAAeListTuple.0
    static let siSbUAAeBysize = Constants.plSbUAAeListTuple.1
    static let plSbUAAeBysize = Constants.plSbUAAeListTuple.2
    static let plSbUAAe  = Constants.plSbUAAeListTuple.3!
    
    // CLASSICAL "..a" -> "..ae"
    static let plSbCAAeListTemp = [
        "amoeba", "antenna", "formula", "hyperbola",
        "medusa", "nebula", "parabola", "abscissa",
        "hydra", "nova", "lacuna", "aurora", "umbra",
        "flora", "fauna"
    ]
    
    private static let plSbCAAeListTuple = makePlSiLists(Constants.plSbCAAeListTemp, plending: "e", siendingSize: 0)
    static let siSbCAAeList = Constants.plSbCAAeListTuple.0
    static let siSbCAAeBysize = Constants.plSbCAAeListTuple.1
    static let plSbCAAeBysize = Constants.plSbCAAeListTuple.2
    static let plSbCAAe  = Constants.plSbCAAeListTuple.3!
    
    // CLASSICAL "..en" -> "..ina"
    
    static let pl_sb_C_en_ina_list_temp = [
    "stamen", "foramen", "lumen"
    ]
    
    static let si_sb_C_en_ina_list_tuple = makePlSiLists(pl_sb_C_en_ina_list_temp, plending: "ina", siendingSize: 2)
    
    static let si_sb_C_en_ina_list = Constants.si_sb_C_en_ina_list_tuple.0
    static let si_sb_C_en_ina_bysize = Constants.si_sb_C_en_ina_list_tuple.1
    static let pl_sb_C_en_ina_bysize = Constants.si_sb_C_en_ina_list_tuple.2
    static let pl_sb_C_en_ina = Constants.si_sb_C_en_ina_list_tuple.3!
    
    
    // UNCONDITIONAL "..um" -> "..a"
    
    static let pl_sb_U_um_a_list_temp = [
        "bacterium", "agendum", "desideratum", "erratum",
        "stratum", "datum", "ovum", "extremum",
        "candelabrum"
    ]
    
    static let si_sb_U_um_a_list_tuple = makePlSiLists(pl_sb_U_um_a_list_temp, plending: "a", siendingSize: 2)
    
    static let si_sb_U_um_a_list = si_sb_U_um_a_list_tuple.0
    static let si_sb_U_um_a_bysize = si_sb_U_um_a_list_tuple.1
    static let pl_sb_U_um_a_bysize = si_sb_U_um_a_list_tuple.2
    static let pl_sb_U_um_a = si_sb_U_um_a_list_tuple.3!
    
    // CLASSICAL "..um" -> "..a"
    
    static let pl_sb_C_um_a_list_temp = [
        "maximum", "minimum", "momentum", "optimum",
        "quantum", "cranium", "curriculum", "dictum",
        "phylum", "aquarium", "compendium", "emporium",
        "enconium", "gymnasium", "honorarium", "interregnum",
        "lustrum", "memorandum", "millennium", "rostrum",
        "spectrum", "speculum", "stadium", "trapezium",
        "ultimatum", "medium", "vacuum", "velum",
        "consortium", "arboretum"
    ]
    
    static let si_sb_C_um_a_list_tuple = makePlSiLists(pl_sb_C_um_a_list_temp, plending: "a", siendingSize: 2)
    
    static let si_sb_C_um_a_list = si_sb_C_um_a_list_tuple.0
    static let si_sb_C_um_a_bysize = si_sb_C_um_a_list_tuple.1
    static let pl_sb_C_um_a_bysize = si_sb_C_um_a_list_tuple.2
    static let pl_sb_C_um_a = si_sb_C_um_a_list_tuple.3!
    
    
    // UNCONDITIONAL "..us" -> "i"
    static let pl_sb_U_us_i_list_temp = [
        "alumnus", "alveolus", "bacillus", "bronchus",
        "locus", "nucleus", "stimulus", "meniscus",
        "sarcophagus"
    ]
    
    static let si_sb_U_us_i_list_tuple = makePlSiLists(pl_sb_U_us_i_list_temp, plending: "i", siendingSize: 2)
    
    static let si_sb_U_us_i_list = si_sb_U_us_i_list_tuple.0
    static let si_sb_U_us_i_bysize = si_sb_U_us_i_list_tuple.1
    static let pl_sb_U_us_i_bysize = si_sb_U_us_i_list_tuple.2
    static let pl_sb_U_us_i = si_sb_U_us_i_list_tuple.3!
    
    // CLASSICAL "..us" -> "..i"
    static let pl_sb_C_us_i_list_temp = [
        "focus", "radius", "genius",
        "incubus", "succubus", "nimbus",
        "fungus", "nucleolus", "stylus",
        "torus", "umbilicus", "uterus",
        "hippopotamus", "cactus"
    ]
    
    static let si_sb_C_us_i_list_tuple = makePlSiLists(pl_sb_C_us_i_list_temp, plending: "i", siendingSize: 2)
    
    static let si_sb_C_us_i_list = si_sb_C_us_i_list_tuple.0
    static let si_sb_C_us_i_bysize = si_sb_C_us_i_list_tuple.1
    static let pl_sb_C_us_i_bysize = si_sb_C_us_i_list_tuple.2
    static let pl_sb_C_us_i = si_sb_C_us_i_list_tuple.3!
    
    
    // CLASSICAL "..us" -> "..us"  (ASSIMILATED 4TH DECLENSION LATIN NOUNS)
    static let pl_sb_C_us_us = [
        "status", "apparatus", "prospectus", "sinus",
        "hiatus", "impetus", "plexus"
    ]
    static let pl_sb_C_us_us_bysize = sortBySize(pl_sb_C_us_us)
    
    // UNCONDITIONAL "..on" -> "a"
    static let pl_sb_U_on_a_list_temp = [
        "criterion", "perihelion", "aphelion",
        "phenomenon", "prolegomenon", "noumenon",
        "organon", "asyndeton", "hyperbaton"
    ]
    
    static let si_sb_U_on_a_list_tuple = makePlSiLists(pl_sb_U_on_a_list_temp, plending: "a", siendingSize: 2)
    
    static let si_sb_U_on_a_list = si_sb_U_on_a_list_tuple.0
    static let si_sb_U_on_a_bysize = si_sb_U_on_a_list_tuple.1
    static let pl_sb_U_on_a_bysize = si_sb_U_on_a_list_tuple.2
    static let pl_sb_U_on_a = si_sb_U_on_a_list_tuple.3!
    
    // CLASSICAL "..on" -> "..a"
    
    static let pl_sb_C_on_a_list_temp = [
    "oxymoron"
    ]
    
    static let pl_sb_C_on_a_list_tuple = makePlSiLists(pl_sb_C_on_a_list_temp, plending: "a", siendingSize: 2)
    
    static let si_sb_C_on_a_list = pl_sb_C_on_a_list_tuple.0
    static let si_sb_C_on_a_bysize = pl_sb_C_on_a_list_tuple.1
    static let pl_sb_C_on_a_bysize = pl_sb_C_on_a_list_tuple.2
    static let pl_sb_C_on_a = pl_sb_C_on_a_list_tuple.3!
    
    
    // CLASSICAL "..o" -> "..i"  (BUT NORMALLY -> "..os")
    static let pl_sb_C_o_i = [
        "solo", "soprano", "basso", "alto",
        "contralto", "tempo", "piano", "virtuoso"
    ]
    
    // list not tuple so can concat for pl_sb_U_o_os
    
    static let pl_sb_C_o_i_bysize = sortBySize(pl_sb_C_o_i)
    static let si_sb_C_o_i_bysize = sortBySize(pl_sb_C_o_i.map { "\(String($0.dropLast(1)))i" })
    
    static let pl_sb_C_o_i_stems = joinStem(cutPoint: 1, words: pl_sb_C_o_i)
    
    // ALWAYS "..o" -> "..os"
    static let pl_sb_U_o_os_complete = [
        "ado", "ISO", "NATO", "NCO", "NGO", "oto"
    ]
    static let si_sb_U_o_os_complete = pl_sb_U_o_os_complete.map { "\($0)s" }
    
    
    static let pl_sb_U_o_os_endings = [
        "aficionado", "aggro",
        "albino", "allegro", "ammo",
        "Antananarivo", "archipelago", "armadillo",
        "auto", "avocado", "Bamako",
        "Barquisimeto", "bimbo", "bingo",
        "Biro", "bolero", "Bolzano",
        "bongo", "Boto", "burro",
        "Cairo", "canto", "cappuccino",
        "casino", "cello", "Chicago",
        "Chimango", "cilantro", "cochito",
        "coco", "Colombo", "Colorado",
        "commando", "concertino", "contango",
        "credo", "crescendo", "cyano",
        "demo", "ditto", "Draco",
        "dynamo", "embryo", "Esperanto",
        "espresso", "euro", "falsetto",
        "Faro", "fiasco", "Filipino",
        "flamenco", "furioso", "generalissimo",
        "Gestapo", "ghetto", "gigolo",
        "gizmo", "Greensboro", "gringo",
        "Guaiabero", "guano", "gumbo",
        "gyro", "hairdo", "hippo",
        "Idaho", "impetigo", "inferno",
        "info", "intermezzo", "intertrigo",
        "Iquico", "jumbo",
        "junto", "Kakapo", "kilo",
        "Kinkimavo", "Kokako", "Kosovo",
        "Lesotho", "libero", "libido",
        "libretto", "lido", "Lilo",
        "limbo", "limo", "lineno",
        "lingo", "lino", "livedo",
        "loco", "logo", "lumbago",
        "macho", "macro", "mafioso",
        "magneto", "magnifico", "Majuro",
        "Malabo", "manifesto", "Maputo",
        "Maracaibo", "medico", "memo",
        "metro", "Mexico", "micro",
        "Milano", "Monaco", "mono",
        "Montenegro", "Morocco", "Muqdisho",
        "myo",
        "neutrino", "Ningbo",
        "octavo", "oregano", "Orinoco",
        "Orlando", "Oslo",
        "panto", "Paramaribo", "Pardusco",
        "pedalo", "photo", "pimento",
        "pinto", "pleco", "Pluto",
        "pogo", "polo", "poncho",
        "Porto-Novo", "Porto", "pro",
        "psycho", "pueblo", "quarto",
        "Quito", "rhino", "risotto",
        "rococo", "rondo", "Sacramento",
        "saddo", "sago", "salvo",
        "Santiago", "Sapporo", "Sarajevo",
        "scherzando", "scherzo", "silo",
        "sirocco", "sombrero", "staccato",
        "sterno", "stucco", "stylo",
        "sumo", "Taiko", "techno",
        "terrazzo", "testudo", "timpano",
        "tiro", "tobacco", "Togo",
        "Tokyo", "torero", "Torino",
        "Toronto", "torso", "tremolo",
        "typo", "tyro", "ufo",
        "UNESCO", "vaquero", "vermicello",
        "verso", "vibrato", "violoncello",
        "Virgo", "weirdo", "WHO",
        "WTO", "Yamoussoukro", "yo-yo",
        "zero", "Zibo"
    ] + pl_sb_C_o_i
    
    static let pl_sb_U_o_os_bysize = sortBySize(pl_sb_U_o_os_endings)
    static let si_sb_U_o_os_bysize = sortBySize(pl_sb_U_o_os_endings.map { "\($0)s" })
    
    
    // Mark: UNCONDITIONAL "..ch" -> "..chs"
    static let pl_sb_U_ch_chs_list_temp = [
        "czech", "eunuch", "stomach"
    ]
    
    static let si_sb_U_ch_chs_list_tuple = makePlSiLists(pl_sb_U_ch_chs_list_temp, plending: "s", siendingSize: 0)
    
    static let si_sb_U_ch_chs_list = si_sb_U_ch_chs_list_tuple.0
    static let si_sb_U_ch_chs_bysize = si_sb_U_ch_chs_list_tuple.1
    static let pl_sb_U_ch_chs_bysize = si_sb_U_ch_chs_list_tuple.2
    static let pl_sb_U_ch_chs = si_sb_U_ch_chs_list_tuple.3!
    
    
    // UNCONDITIONAL "..[ei]x" -> "..ices"
    static let pl_sb_U_ex_ices_list_temp = [
        "codex", "murex", "silex"
    ]
    
    static let pl_sb_U_ex_ices_list_tuple = makePlSiLists(pl_sb_U_ex_ices_list_temp, plending: "ices", siendingSize: 2)
    
    static let si_sb_U_ex_ices_list = pl_sb_U_ex_ices_list_tuple.0
    static let si_sb_U_ex_ices_bysize = pl_sb_U_ex_ices_list_tuple.1
    static let pl_sb_U_ex_ices_bysize = pl_sb_U_ex_ices_list_tuple.2
    static let pl_sb_U_ex_ices = pl_sb_U_ex_ices_list_tuple.3!
    
    static let pl_sb_U_ix_ices_list_temp = [
        "radix", "helix"
    ]
    
    static let si_sb_U_ix_ices_list_tuple = makePlSiLists(pl_sb_U_ix_ices_list_temp, plending: "ices", siendingSize: 2)
    
    static let si_sb_U_ix_ices_list = si_sb_U_ix_ices_list_tuple.0
    static let si_sb_U_ix_ices_bysize = si_sb_U_ix_ices_list_tuple.1
    static let pl_sb_U_ix_ices_bysize = si_sb_U_ix_ices_list_tuple.2
    static let pl_sb_U_ix_ices = si_sb_U_ix_ices_list_tuple.3!
    
    // CLASSICAL "..[ei]x" -> "..ices"
    static let pl_sb_C_ex_ices_list_temp = [
        "vortex", "vertex", "cortex", "latex",
        "pontifex", "apex", "index", "simplex"
    ]
    
    static let pl_sb_C_ex_ices_list_tuple = makePlSiLists(pl_sb_C_ex_ices_list_temp, plending: "ices", siendingSize: 2)
    
    static let si_sb_C_ex_ices_list = pl_sb_C_ex_ices_list_tuple.0
    static let si_sb_C_ex_ices_bysize = pl_sb_C_ex_ices_list_tuple.1
    static let pl_sb_C_ex_ices_bysize = pl_sb_C_ex_ices_list_tuple.2
    static let pl_sb_C_ex_ices = pl_sb_C_ex_ices_list_tuple.3!
    
    
    
}

extension Array {
    func appending(contentsOf sequence: Array) -> Array {
        var mutatingSelf = self
        mutatingSelf.append(contentsOf: sequence)
        return mutatingSelf
    }
}
