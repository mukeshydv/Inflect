//
//  Rules.swift
//  Inflect
//
//  Created by Mukesh on 14/08/18.
//

enum Rules {
    
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
        return cuttedString.joined(separator: "|").enclose()
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
    
    static let pl_sb_irregular_s = [
        "corpus": "corpuses|corpora",
        "opus":   "opuses|opera",
        "genus":  "genera",
        "mythos": "mythoi",
        "penis":  "penises|penes",
        "testis": "testes",
        "atlas":  "atlases|atlantes",
        "yes":    "yeses"
    ]
    
    static let plSbIrregular: [String: String] = [
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
        "carmen":     "carmina"
        ] + pl_sb_irregular_s
    
    static var siSbIrregular = updateKeys(dict: Dictionary(uniqueKeysWithValues: plSbIrregular.map { ($1, $0) }))
    
    static let plSbIrregularCaps = [
        "Romany": "Romanies",
        "Jerry":  "Jerrys",
        "Mary":   "Marys",
        "Rom":    "Roma"
    ]
    
    static let siSbIrregularCaps = Dictionary(uniqueKeysWithValues: plSbIrregularCaps.map { ($1, $0) })
    
    static let plSbIrregularCompound = [
        "prima donna": "prima donnas|prime donne"
    ]
    
    static let siSbIrregularCompound = updateKeys(dict: Dictionary(uniqueKeysWithValues: plSbIrregularCompound.map { ($1, $0) }))
    
    // Z"s that don"t double
    static let plSbZZesList = [
        "quartz", "topaz"
    ]
    
    static let plSbZZesBySize = sortBySize(plSbZZesList)
    
    static let plSbZeZesList = [
        "snooze"
    ]
    
    static let plSbZeZesBySize = sortBySize(plSbZeZesList)
    
    // CLASSICAL "..is" -> "..ides"
    static let pl_sb_C_is_ides_complete = [
        // GENERAL WORDS...
        "ephemeris", "iris", "clitoris",
        "chrysalis", "epididymis"
    ]
    
    static let pl_sb_C_is_ides_endings = [
        // INFLAMATIONS...
        "itis"
    ]
    
    static let plSbCIsIdes = joinStem(cutPoint: 2, words: pl_sb_C_is_ides_complete.appending(contentsOf: pl_sb_C_is_ides_endings.map { ".*\($0)" }))
    
    static let plSbCIsIdesListTemp = pl_sb_C_is_ides_complete.appending(contentsOf: pl_sb_C_is_ides_endings)
    
    private static let siSbCIsIdesListTuple = makePlSiLists(plSbCIsIdesListTemp, plending: "ides", siendingSize: 2, doJoinStem: false)
    
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
    
    private static let plSbCAAtaListTuple = makePlSiLists(plSbCAAtaList, plending: "ata", siendingSize: 1)
    static let siSbCAAtaList = plSbCAAtaListTuple.0
    static let siSbCAAtaBysize = plSbCAAtaListTuple.1
    static let plSbCAAtaBysize = plSbCAAtaListTuple.2
    static let plSbCAAta  = plSbCAAtaListTuple.3!
    
    // UNCONDITIONAL "..a" -> "..ae"
    static let plSbUAAeListTemp = [
        "alumna", "alga", "vertebra", "persona"
    ]
    
    private static let plSbUAAeListTuple = makePlSiLists(plSbUAAeListTemp, plending: "e", siendingSize: 0)
    static let siSbUAAeList = plSbUAAeListTuple.0
    static let siSbUAAeBysize = plSbUAAeListTuple.1
    static let plSbUAAeBysize = plSbUAAeListTuple.2
    static let plSbUAAe  = plSbUAAeListTuple.3!
    
    // CLASSICAL "..a" -> "..ae"
    static let plSbCAAeListTemp = [
        "amoeba", "antenna", "formula", "hyperbola",
        "medusa", "nebula", "parabola", "abscissa",
        "hydra", "nova", "lacuna", "aurora", "umbra",
        "flora", "fauna"
    ]
    
    private static let plSbCAAeListTuple = makePlSiLists(plSbCAAeListTemp, plending: "e", siendingSize: 0)
    static let siSbCAAeList = plSbCAAeListTuple.0
    static let siSbCAAeBysize = plSbCAAeListTuple.1
    static let plSbCAAeBysize = plSbCAAeListTuple.2
    static let plSbCAAe  = plSbCAAeListTuple.3!
    
    // CLASSICAL "..en" -> "..ina"
    
    static let pl_sb_C_en_ina_list_temp = [
        "stamen", "foramen", "lumen"
    ]
    
    static let si_sb_C_en_ina_list_tuple = makePlSiLists(pl_sb_C_en_ina_list_temp, plending: "ina", siendingSize: 2)
    
    static let si_sb_C_en_ina_list = si_sb_C_en_ina_list_tuple.0
    static let si_sb_C_en_ina_bysize = si_sb_C_en_ina_list_tuple.1
    static let pl_sb_C_en_ina_bysize = si_sb_C_en_ina_list_tuple.2
    static let pl_sb_C_en_ina = si_sb_C_en_ina_list_tuple.3!
    
    
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
    
    
    static let pl_sb_C_ix_ices_list_temp = [
        "appendix"
    ]
    
    static let pl_sb_C_ix_ices_list_tuple = makePlSiLists(pl_sb_C_ix_ices_list_temp, plending: "ices", siendingSize: 2)
    
    static let si_sb_C_ix_ices_list = pl_sb_C_ix_ices_list_tuple.0
    static let si_sb_C_ix_ices_bysize = pl_sb_C_ix_ices_list_tuple.1
    static let pl_sb_C_ix_ices_bysize = pl_sb_C_ix_ices_list_tuple.2
    static let pl_sb_C_ix_ices = pl_sb_C_ix_ices_list_tuple.3!
    
    
    // ARABIC: ".." -> "..i"
    static let pl_sb_C_i_list_temp = [
        "afrit", "afreet", "efreet"
    ]
    
    static let pl_sb_C_i_list_tuple = makePlSiLists(pl_sb_C_i_list_temp, plending: "i", siendingSize: 0)
    
    static let si_sb_C_i_list = pl_sb_C_i_list_tuple.0
    static let si_sb_C_i_bysize = pl_sb_C_i_list_tuple.1
    static let pl_sb_C_i_bysize = pl_sb_C_i_list_tuple.2
    static let pl_sb_C_i = pl_sb_C_i_list_tuple.3!
    
    
    // HEBREW: ".." -> "..im"
    
    static let pl_sb_C_im_list_temp = [
        "goy", "seraph", "cherub"
    ]
    
    static let pl_sb_C_im_list_tuple = makePlSiLists(pl_sb_C_im_list_temp, plending: "im", siendingSize: 0)
    
    static let si_sb_C_im_list = pl_sb_C_im_list_tuple.0
    static let si_sb_C_im_bysize = pl_sb_C_im_list_tuple.1
    static let pl_sb_C_im_bysize = pl_sb_C_im_list_tuple.2
    static let pl_sb_C_im = pl_sb_C_im_list_tuple.3!
    
    
    // UNCONDITIONAL "..man" -> "..mans"
    static let pl_sb_U_man_mans_list_temp = [
        "ataman", "caiman", "cayman", "ceriman",
        "desman", "dolman", "farman", "harman", "hetman",
        "human", "leman", "ottoman", "shaman", "talisman"
    ]
    
    static let pl_sb_U_man_mans_caps_list_temp = [
        "Alabaman", "Bahaman", "Burman", "German",
        "Hiroshiman", "Liman", "Nakayaman", "Norman", "Oklahoman",
        "Panaman", "Roman", "Selman", "Sonaman", "Tacoman", "Yakiman",
        "Yokohaman", "Yuman"
    ]
    
    static let pl_sb_U_man_mans_list_tuple = makePlSiLists(pl_sb_U_man_mans_list_temp, plending: "s", siendingSize: 0, doJoinStem: false)
    
    static let si_sb_U_man_mans_list = pl_sb_U_man_mans_list_tuple.0
    static let si_sb_U_man_mans_bysize = pl_sb_U_man_mans_list_tuple.1
    static let pl_sb_U_man_mans_bysize = pl_sb_U_man_mans_list_tuple.2
    
    static let si_sb_U_man_mans_caps_list_tuple = makePlSiLists(pl_sb_U_man_mans_caps_list_temp, plending: "s", siendingSize: 0, doJoinStem: false)
    
    static let si_sb_U_man_mans_caps_list = si_sb_U_man_mans_caps_list_tuple.0
    static let si_sb_U_man_mans_caps_bysize = si_sb_U_man_mans_caps_list_tuple.1
    static let pl_sb_U_man_mans_caps_bysize = si_sb_U_man_mans_caps_list_tuple.2
    
    
    static let pl_sb_uninflected_s_complete = [
        // PAIRS OR GROUPS SUBSUMED TO A SINGULAR...
        "breeches", "britches", "pajamas", "pyjamas", "clippers", "gallows",
        "hijinks", "headquarters", "pliers", "scissors", "testes", "herpes",
        "pincers", "shears", "proceedings", "trousers",
        
        // UNASSIMILATED LATIN 4th DECLENSION
        
        "cantus", "coitus", "nexus",
        
        // RECENT IMPORTS...
        "contretemps", "corps", "debris",
        "siemens",
        
        // DISEASES
        "mumps",
        
        // MISCELLANEOUS OTHERS...
        "diabetes", "jackanapes", "series", "species", "subspecies", "rabies",
        "chassis", "innings", "news", "mews", "haggis"
    ]
    
    static let pl_sb_uninflected_s_endings = [
        // RECENT IMPORTS...
        "ois",
        
        // DISEASES
        "measles"
    ]
    
    static let pl_sb_uninflected_s = pl_sb_uninflected_s_complete + pl_sb_uninflected_s_endings.map { ".*\($0)" }
    
    static let pl_sb_uninflected_herd = [
        // DON"T INFLECT IN CLASSICAL MODE, OTHERWISE NORMAL INFLECTION
        "wildebeest", "swine", "eland", "bison", "buffalo",
        "elk", "rhinoceros", "zucchini",
        "caribou", "dace", "grouse", "guinea fowl", "guinea-fowl",
        "haddock", "hake", "halibut", "herring", "mackerel",
        "pickerel", "pike", "roe", "seed", "shad",
        "snipe", "teal", "turbot", "water fowl", "water-fowl"
    ]
    
    static let pl_sb_uninflected_complete = [
        // SOME FISH AND HERD ANIMALS
        "tuna", "salmon", "mackerel", "trout",
        "bream", "sea-bass", "sea bass", "carp", "cod", "flounder", "whiting",
        "moose",
        
        // OTHER ODDITIES
        "graffiti", "djinn", "samuri",
        "offspring", "pence", "quid", "hertz"
        ] + pl_sb_uninflected_s_complete
    
    // SOME WORDS ENDING IN ...s (OFTEN PAIRS TAKEN AS A WHOLE)
    
    static let pl_sb_uninflected_caps = [
        // ALL NATIONALS ENDING IN -ese
        "Portuguese", "Amoyese", "Borghese", "Congoese", "Faroese",
        "Foochowese", "Genevese", "Genoese", "Gilbertese", "Hottentotese",
        "Kiplingese", "Kongoese", "Lucchese", "Maltese", "Nankingese",
        "Niasese", "Pekingese", "Piedmontese", "Pistoiese", "Sarawakese",
        "Shavese", "Vermontese", "Wenchowese", "Yengeese"
    ]
    
    static let pl_sb_uninflected_endings = [
        // SOME FISH AND HERD ANIMALS
        "fish",
        
        "deer", "sheep",
        
        // ALL NATIONALS ENDING IN -ese
        "nese", "rese", "lese", "mese",
        
        // DISEASES
        "pox",
        
        // OTHER ODDITIES
        "craft"
        ] + pl_sb_uninflected_s_endings
    
    // SOME WORDS ENDING IN ...s (OFTEN PAIRS TAKEN AS A WHOLE)
    
    
    static let pl_sb_uninflected_bysize = sortBySize(pl_sb_uninflected_endings)
    
    
    // SINGULAR WORDS ENDING IN ...s (ALL INFLECT WITH ...es)
    
    static let pl_sb_singular_s_complete = [
        "acropolis", "aegis", "alias", "asbestos", "bathos", "bias",
        "bronchitis", "bursitis", "caddis", "cannabis",
        "canvas", "chaos", "cosmos", "dais", "digitalis",
        "epidermis", "ethos", "eyas", "gas", "glottis",
        "hubris", "ibis", "lens", "mantis", "marquis", "metropolis",
        "pathos", "pelvis", "polis", "rhinoceros",
        "sassafras", "trellis"
        ] + pl_sb_C_is_ides_complete
    
    
    static let pl_sb_singular_s_endings = [
        "ss", "us"
        ] + pl_sb_C_is_ides_endings
    
    static let pl_sb_singular_s_bysize = sortBySize(pl_sb_singular_s_endings)
    
    static let si_sb_singular_s_complete = pl_sb_singular_s_complete.map { "\($0)es" }
    static let si_sb_singular_s_endings = pl_sb_singular_s_endings.map { "\($0)es" }
    static let si_sb_singular_s_bysize = sortBySize(si_sb_singular_s_endings)
    
    static let pl_sb_singular_s_es = [
        "[A-Z].*es"
    ]
    
    static let pl_sb_singular_s = "|".join(pl_sb_singular_s_complete + pl_sb_singular_s_endings.map { ".*\($0)" } + pl_sb_singular_s_es).enclose()
    
    // PLURALS ENDING IN uses -> use
    static let si_sb_ois_oi_case = [
        "Bolshois", "Hanois"
    ]
    
    static let si_sb_uses_use_case = [
        "Betelgeuses", "Duses", "Meuses", "Syracuses", "Toulouses"
    ]
    
    static let si_sb_uses_use = [
        "abuses", "applauses", "blouses",
        "carouses", "causes", "chartreuses", "clauses",
        "contuses", "douses", "excuses", "fuses",
        "grouses", "hypotenuses", "masseuses",
        "menopauses", "misuses", "muses", "overuses", "pauses",
        "peruses", "profuses", "recluses", "reuses",
        "ruses", "souses", "spouses", "suffuses", "transfuses", "uses"
    ]
    
    static let si_sb_ies_ie_case = [
        "Addies", "Aggies", "Allies", "Amies", "Angies", "Annies",
        "Annmaries", "Archies", "Arties", "Aussies", "Barbies",
        "Barries", "Basies", "Bennies", "Bernies", "Berties", "Bessies",
        "Betties", "Billies", "Blondies", "Bobbies", "Bonnies",
        "Bowies", "Brandies", "Bries", "Brownies", "Callies",
        "Carnegies", "Carries", "Cassies", "Charlies", "Cheries",
        "Christies", "Connies", "Curies", "Dannies", "Debbies", "Dixies",
        "Dollies", "Donnies", "Drambuies", "Eddies", "Effies", "Ellies",
        "Elsies", "Eries", "Ernies", "Essies", "Eugenies", "Fannies",
        "Flossies", "Frankies", "Freddies", "Gillespies", "Goldies",
        "Gracies", "Guthries", "Hallies", "Hatties", "Hetties",
        "Hollies", "Jackies", "Jamies", "Janies", "Jannies", "Jeanies",
        "Jeannies", "Jennies", "Jessies", "Jimmies", "Jodies", "Johnies",
        "Johnnies", "Josies", "Julies", "Kalgoorlies", "Kathies", "Katies",
        "Kellies", "Kewpies", "Kristies", "Laramies", "Lassies", "Lauries",
        "Leslies", "Lessies", "Lillies", "Lizzies", "Lonnies", "Lories",
        "Lorries", "Lotties", "Louies", "Mackenzies", "Maggies", "Maisies",
        "Mamies", "Marcies", "Margies", "Maries", "Marjories", "Matties",
        "McKenzies", "Melanies", "Mickies", "Millies", "Minnies", "Mollies",
        "Mounties", "Nannies", "Natalies", "Nellies", "Netties", "Ollies",
        "Ozzies", "Pearlies", "Pottawatomies", "Reggies", "Richies", "Rickies",
        "Robbies", "Ronnies", "Rosalies", "Rosemaries", "Rosies", "Roxies",
        "Rushdies", "Ruthies", "Sadies", "Sallies", "Sammies", "Scotties",
        "Selassies", "Sherries", "Sophies", "Stacies", "Stefanies", "Stephanies",
        "Stevies", "Susies", "Sylvies", "Tammies", "Terries", "Tessies",
        "Tommies", "Tracies", "Trekkies", "Valaries", "Valeries", "Valkyries",
        "Vickies", "Virgies", "Willies", "Winnies", "Wylies", "Yorkies"
    ]
    
    static let si_sb_ies_ie = [
        "aeries", "baggies", "belies", "biggies", "birdies", "bogies",
        "bonnies", "boogies", "bookies", "bourgeoisies", "brownies",
        "budgies", "caddies", "calories", "camaraderies", "cockamamies",
        "collies", "cookies", "coolies", "cooties", "coteries", "crappies",
        "curies", "cutesies", "dogies", "eyrie", "floozies", "footsies",
        "freebies", "genies", "goalies", "groupies",
        "hies", "jalousies", "junkies",
        "kiddies", "laddies", "lassies", "lies",
        "lingeries", "magpies", "menageries", "mommies", "movies", "neckties",
        "newbies", "nighties", "oldies", "organdies", "overlies",
        "pies", "pinkies", "pixies", "potpies", "prairies",
        "quickies", "reveries", "rookies", "rotisseries", "softies", "sorties",
        "species", "stymies", "sweeties", "ties", "underlies", "unties",
        "veggies", "vies", "yuppies", "zombies"
    ]
    
    static let si_sb_oes_oe_case = [
        "Chloes", "Crusoes", "Defoes", "Faeroes", "Ivanhoes", "Joes",
        "McEnroes", "Moes", "Monroes", "Noes", "Poes", "Roscoes",
        "Tahoes", "Tippecanoes", "Zoes"
    ]
    
    static let si_sb_oes_oe = [
        "aloes", "backhoes", "canoes",
        "does", "floes", "foes", "hoes", "mistletoes",
        "oboes", "pekoes", "roes", "sloes",
        "throes", "tiptoes", "toes", "woes"
    ]
    
    static let si_sb_z_zes = [
        "quartzes", "topazes"
    ]
    
    static let si_sb_zzes_zz = [
        "buzzes", "fizzes", "frizzes", "razzes"
    ]
    
    static let si_sb_ches_che_case = [
        "Andromaches", "Apaches", "Blanches", "Comanches",
        "Nietzsches", "Porsches", "Roches"
    ]
    
    static let si_sb_ches_che = [
        "aches", "avalanches", "backaches", "bellyaches", "caches",
        "cloches", "creches", "douches", "earaches", "fiches",
        "headaches", "heartaches", "microfiches",
        "niches", "pastiches", "psyches", "quiches",
        "stomachaches", "toothaches"
    ]
    
    static let si_sb_xes_xe = [
        "annexes", "axes", "deluxes", "pickaxes"
    ]
    
    static let si_sb_sses_sse_case = [
        "Hesses", "Jesses", "Larousses", "Matisses"
    ]
    
    static let si_sb_sses_sse = [
        "bouillabaisses", "crevasses", "demitasses", "impasses",
        "mousses", "posses"
    ]
    
    static let si_sb_ves_ve_case = [
        // *[nwl]ives -> [nwl]live
        "Clives", "Palmolives"
    ]
    
    static let si_sb_ves_ve = [
        // *[^d]eaves -> eave
        "interweaves", "weaves",
        
        // *[nwl]ives -> [nwl]live
        "olives",
        
        // *[eoa]lves -> [eoa]lve
        "bivalves", "dissolves", "resolves", "salves", "twelves", "valves"
    ]
    
    
    static let plverb_special_s = "|".join([pl_sb_singular_s] + pl_sb_uninflected_s + pl_sb_irregular_s.keys + ["(.*[csx])is", "(.*)ceps", "[A-Z].*s"]).enclose()
    
    static let pl_sb_postfix_adj = [
        "general": ["(?!major|lieutenant|brigadier|adjutant|.*star)\\S+"],
        "martial": ["court"]
        ].postfixEnclosed()
    
    static let pl_sb_postfix_adj_stems = "(" + "|".join(pl_sb_postfix_adj.values.map { $0 }) + ")(.*)"
    
    // PLURAL WORDS ENDING IS es GO TO SINGULAR is
    static let si_sb_es_is = [
        "amanuenses", "amniocenteses", "analyses", "antitheses",
        "apotheoses", "arterioscleroses", "atheroscleroses", "axes",
        "bases", // bases -> basis
        "catalyses", "catharses", "chasses", "cirrhoses",
        "cocces", "crises", "diagnoses", "dialyses", "diereses",
        "electrolyses", "emphases", "exegeses", "geneses",
        "halitoses", "hydrolyses", "hypnoses", "hypotheses", "hystereses",
        "metamorphoses", "metastases", "misdiagnoses", "mitoses",
        "mononucleoses", "narcoses", "necroses", "nemeses", "neuroses",
        "oases", "osmoses", "osteoporoses", "paralyses", "parentheses",
        "parthenogeneses", "periphrases", "photosyntheses", "probosces",
        "prognoses", "prophylaxes", "prostheses", "preces", "psoriases",
        "psychoanalyses", "psychokineses", "psychoses", "scleroses",
        "scolioses", "sepses", "silicoses", "symbioses", "synopses",
        "syntheses", "taxes", "telekineses", "theses", "thromboses",
        "tuberculoses", "urinalyses"
    ]
    
    static let pl_prep_list = [
        "about", "above", "across", "after", "among", "around", "at", "athwart", "before", "behind",
        "below", "beneath", "beside", "besides", "between", "betwixt", "beyond", "but", "by",
        "during", "except", "for", "from", "in", "into", "near", "of", "off", "on", "onto", "out", "over",
        "since", "till", "to", "under", "until", "unto", "upon", "with"
    ]
    
    static let pl_prep_list_da = pl_prep_list + ["de", "du", "da"]
    
    static let pl_prep_bysize = sortBySize(pl_prep_list_da)
    
    static let pl_prep = "|".join(pl_prep_list_da).enclose()
    
    static let pl_sb_prep_dual_compound = "(.*?)((?:-|\\s+)(?:" + pl_prep + ")(?:-|\\s+))a(?:-|\\s+)(.*)"
    
    static let singular_pronoun_genders = [
        "neuter",
        "feminine",
        "masculine",
        "gender-neutral",
        "feminine or masculine",
        "masculine or feminine"
    ]
    
    static let pl_pron_nom = [
        // NOMINATIVE    REFLEXIVE
        "i":    "we", "myself":   "ourselves",
        "you":  "you", "yourself": "yourselves",
        "she":  "they", "herself":  "themselves",
        "he":   "they", "himself":  "themselves",
        "it":   "they", "itself":   "themselves",
        "they": "they", "themself": "themselves",
        
        // POSSESSIVE
        "mine": "ours",
        "yours": "yours",
        "hers": "theirs",
        "his": "theirs",
        "its": "theirs",
        "theirs": "theirs"
    ]
    
    
    
    static let pl_pron_acc = [
        // ACCUSATIVE    REFLEXIVE
        "me":   "us", "myself":   "ourselves",
        "you":  "you", "yourself": "yourselves",
        "her":  "them", "herself":  "themselves",
        "him":  "them", "himself":  "themselves",
        "it":   "them", "itself":   "themselves",
        "them": "them", "themself": "themselves"
    ]
    
    static let pl_pron_acc_keys = "|".join(pl_pron_acc.keys.map { $0 }).enclose()
    static let pl_pron_acc_keys_bysize = sortBySize(pl_pron_acc.keys.map { $0 })
    
    
    
    static let thecase_plur_gend_sing_tuple = [
        ("nom", "they", "neuter", "it"),
        ("nom", "they", "feminine", "she"),
        ("nom", "they", "masculine", "he"),
        ("nom", "they", "gender-neutral", "they"),
        ("nom", "they", "feminine or masculine", "she or he"),
        ("nom", "they", "masculine or feminine", "he or she"),
        ("nom", "themselves", "neuter", "itself"),
        ("nom", "themselves", "feminine", "herself"),
        ("nom", "themselves", "masculine", "himself"),
        ("nom", "themselves", "gender-neutral", "themself"),
        ("nom", "themselves", "feminine or masculine", "herself or himself"),
        ("nom", "themselves", "masculine or feminine", "himself or herself"),
        ("nom", "theirs", "neuter", "its"),
        ("nom", "theirs", "feminine", "hers"),
        ("nom", "theirs", "masculine", "his"),
        ("nom", "theirs", "gender-neutral", "theirs"),
        ("nom", "theirs", "feminine or masculine", "hers or his"),
        ("nom", "theirs", "masculine or feminine", "his or hers"),
        ("acc", "them", "neuter", "it"),
        ("acc", "them", "feminine", "her"),
        ("acc", "them", "masculine", "him"),
        ("acc", "them", "gender-neutral", "them"),
        ("acc", "them", "feminine or masculine", "her or him"),
        ("acc", "them", "masculine or feminine", "him or her"),
        ("acc", "themselves", "neuter", "itself"),
        ("acc", "themselves", "feminine", "herself"),
        ("acc", "themselves", "masculine", "himself"),
        ("acc", "themselves", "gender-neutral", "themself"),
        ("acc", "themselves", "feminine or masculine", "herself or himself"),
        ("acc", "themselves", "masculine or feminine", "himself or herself")
    ]
    
    static func createSiPron() -> [String: [String: Any]] {
        var si_pron = [String: [String: Any]]()
        si_pron["nom"] = pl_pron_nom.reversedDict()
        si_pron["nom"]?["we"] = "I"
        
        si_pron["acc"] = pl_pron_acc.reversedDict()
        
        for (thecase, plur, gend, sing) in thecase_plur_gend_sing_tuple {
            if var plurDict = si_pron[thecase]?[plur] as? [String: String] {
                plurDict[gend] = sing
                si_pron[thecase]?[plur] = plurDict
            } else {
                si_pron[thecase]?[plur] = [gend: sing]
            }
        }
        
        return si_pron
    }
    
    static var si_pron = createSiPron()
    
    static let si_pron_acc_keys = "|".join(si_pron["acc"]?.keys.map { $0 } ?? []).enclose()
    static let si_pron_acc_keys_bysize = sortBySize(si_pron["acc"]?.keys.map { $0 } ?? [])
    
    static func get_si_pron(thecase: String, word: String, gender: String) -> String? {
        if let sing = si_pron[thecase]?[word] {
            if sing is String {
                return sing as? String
            } else if let singDict = sing as? [String: String] {
                return singDict[gender]
            }
        }
        return nil
    }
    
    static let plverb_irregular_pres = [
        // 1st PERS. SING.   2ND PERS. SING.   3RD PERS. SINGULAR
        // 3RD PERS. (INDET.)
        "am":   "are", "are":  "are", "is":  "are",
        "was":  "were", "were": "were", "was":  "were",
        "have": "have", "have": "have", "has":  "have",
        "do":   "do", "do":   "do", "does": "do"
    ]
    
    static let plverb_ambiguous_pres = [
        // 1st PERS. SING.  2ND PERS. SING.   3RD PERS. SINGULAR
        // 3RD PERS. (INDET.)
        "act":   "act", "act":   "act", "acts":    "act",
        "blame": "blame", "blame": "blame", "blames":  "blame",
        "can":   "can", "can":   "can", "can":     "can",
        "must":  "must", "must":  "must", "must":    "must",
        "fly":   "fly", "fly":   "fly", "flies":   "fly",
        "copy":  "copy", "copy":  "copy", "copies":  "copy",
        "drink": "drink", "drink": "drink", "drinks":  "drink",
        "fight": "fight", "fight": "fight", "fights":  "fight",
        "fire":  "fire", "fire":  "fire", "fires":   "fire",
        "like":  "like", "like":  "like", "likes":   "like",
        "look":  "look", "look":  "look", "looks":   "look",
        "make":  "make", "make":  "make", "makes":   "make",
        "reach": "reach", "reach": "reach", "reaches": "reach",
        "run":   "run", "run":   "run", "runs":    "run",
        "sink":  "sink", "sink":  "sink", "sinks":   "sink",
        "sleep": "sleep", "sleep": "sleep", "sleeps":  "sleep",
        "view":  "view", "view":  "view", "views":   "view"
    ]
    
    static let plverb_ambiguous_pres_keys = "|".join(plverb_ambiguous_pres.keys.map { $0 }).enclose()
    
    static let plverb_irregular_non_pres = [
        "did", "had", "ate", "made", "put",
        "spent", "fought", "sank", "gave", "sought",
        "shall", "could", "ought", "should"
    ]
    
    static let plverb_ambiguous_non_pres = "|".join(["thought", "saw", "bent", "will", "might", "cut"]).enclose()
    
    // "..oes" -> "..oe" (the rest are "..oes" -> "o")
    static let pl_v_oes_oe = ["canoes", "floes", "oboes", "roes", "throes", "woes"]
    static let pl_v_oes_oe_endings_size4 = ["hoes", "toes"]
    static let pl_v_oes_oe_endings_size5 = ["shoes"]
    
    
    static let pl_count_zero = [
        "0", "no", "zero", "nil"
    ]
    
    
    static let pl_count_one = [
        "1", "a", "an", "one", "each", "every", "this", "that"
    ]
    
    static let pl_adj_special = [
        "a":    "some", "an":    "some",
        "this": "these", "that": "those"
    ]
    
    static let pl_adj_special_keys = "|".join(pl_adj_special.keys.map {$0}).enclose()
    
    static let pl_adj_poss = [
        "my":    "our",
        "your":  "your",
        "its":   "their",
        "her":   "their",
        "his":   "their",
        "their": "their"
    ]
    
    static let pl_adj_poss_keys = "|".join(pl_adj_poss.keys.map {$0}).enclose()
    
    // 2. INDEFINITE ARTICLES
    
    // THIS PATTERN MATCHES STRINGS OF CAPITALS STARTING WITH A "VOWEL-SOUND"
    // CONSONANT FOLLOWED BY ANOTHER CONSONANT, AND WHICH ARE NOT LIKELY
    // TO BE REAL WORDS (OH, ALL RIGHT THEN, IT"S JUST MAGIC!)
    
    static let A_abbrev = """
    (?! FJO | [HLMNS]Y.  | RY[EO] | SQU
    | ( F[LR]? | [HL] | MN? | N | RH? | S[CHKLMNPTVW]? | X(YL)?) [AEIOU])
    [FHLMNRSX][A-Z]
    """
    
    // THIS PATTERN CODES THE BEGINNINGS OF ALL ENGLISH WORDS BEGINING WITH A
    // "y" FOLLOWED BY A CONSONANT. ANY OTHER Y-CONSONANT PREFIX THEREFORE
    // IMPLIES AN ABBREVIATION.
    
    static let A_y_cons = "y(b[lor]|cl[ea]|fere|gg|p[ios]|rou|tt)"
    
    // EXCEPTIONS TO EXCEPTIONS
    
    static let A_explicit_a = "|".join(["unabomber", "unanimous", "US"]).enclose()
    
    static let A_explicit_an = "|".join(["euler",
                                         "hour(?!i)", "heir", "honest", "hono[ur]",
                                         "mpeg"]).enclose()
    
    static let A_ordinal_an = "|".join(["[aefhilmnorsx]-?th"]).enclose()
    
    static let A_ordinal_a = "|".join(["[bcdgjkpqtuvwyz]-?th"]).enclose()
    
    // NUMERICAL INFLECTIONS
    
    static let nth = [
        0: "th",
        1: "st",
        2: "nd",
        3: "rd",
        4: "th",
        5: "th",
        6: "th",
        7: "th",
        8: "th",
        9: "th",
        11: "th",
        12: "th",
        13: "th"
    ]
    
    static let ordinal = [
        "ty": "tieth",
        "one":"first",
        "two":"second",
        "three":"third",
        "five":"fifth",
        "eight":"eighth",
        "nine":"ninth",
        "twelve":"twelfth"
    ]
    
    static let ordinal_suff = "|".join(ordinal.keys.map {$0} )
    
    
    // NUMBERS
    static let unit = ["", "one", "two", "three", "four", "five",
                       "six", "seven", "eight", "nine"]
    static let teen = ["ten", "eleven", "twelve", "thirteen", "fourteen",
                       "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
    static let ten = ["", "", "twenty", "thirty", "forty",
                      "fifty", "sixty", "seventy", "eighty", "ninety"]
    static let mill = [" ", " thousand", " million", " billion", " trillion", " quadrillion",
                       " quintillion", " sextillion", " septillion", " octillion",
                       " nonillion", " decillion"]
    
    
    // SUPPORT CLASSICAL PLURALIZATIONS
    static let def_classical = [
        "all": false,
        "zero": false,
        "herd": false,
        "names": true,
        "persons": false,
        "ancient": false
    ]
    
    static let all_classical = Dictionary(uniqueKeysWithValues: def_classical.keys.map { ($0, true) })
    static let no_classical = Dictionary(uniqueKeysWithValues: def_classical.keys.map { ($0, false) })
    
    
    // TODO: .inflectrc file does not work
    // can"t just execute methods from another file like this
    
    // for rcfile in (pathjoin(dirname(__file__), ".inflectrc"),
    //               expanduser(pathjoin(("~"), ".inflectrc"))):
    //    if isfile(rcfile):
    //        try:
    //            execfile(rcfile)
    //        except:
    //            print3("\nBad .inflectrc file (%s):\n" % rcfile)
    //            raise BadRcFileError
    
}
