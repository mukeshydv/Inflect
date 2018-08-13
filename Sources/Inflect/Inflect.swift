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
    
    
}

extension Array {
    func appending(contentsOf sequence: Array) -> Array {
        var mutatingSelf = self
        mutatingSelf.append(contentsOf: sequence)
        return mutatingSelf
    }
}
