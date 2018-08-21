import Foundation

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
    
    private var classical_dict = Rules.def_classical
    private var persistent_count = 0
    private var mill_count = 0
//    private var pl_sb_user_defined = [(String, String)]()
//    private var pl_v_user_defined = [(String, String, String, String, String, String)]()
//    private var pl_adj_user_defined = [(String, String)]()
//    private var si_sb_user_defined = [(String, String)]()
//    private var A_a_user_defined = [(String, String)]()
    private var thegender = "neuter"
    
    private let deprecated_methods = [
        "pl": "plural",
        "plnoun": "plural_noun",
        "plverb": "plural_verb",
        "pladj": "plural_adj",
        "sinoun": "single_noun",
        "prespart": "present_participle",
        "numwords": "number_to_words",
        "plequal": "compare",
        "plnounequal": "compare_nouns",
        "plverbequal": "compare_verbs'",
        "pladjequal": "compare_adjs",
        "wordlist": "join"
    ]
    
    func getMethod(_ method: String) throws -> String {
        if deprecated_methods.keys.contains(method) {
            print(String(format: "%@() deprecated, use %@()", method, deprecated_methods[method]!))
        }
        return ""
    }
    
//    func defNoun(singular: String, plural: String) throws {
//        try checkPat(singular)
//        try checkPatPlural(plural)
//        pl_sb_user_defined.append((singular, plural))
//        si_sb_user_defined.append((plural, singular))
//    }
//
//    func defVerb(s1: String, p1: String, s2: String, p2: String, s3: String, p3: String) {
//        try? checkPat(s1)
//        try? checkPat(s2)
//        try? checkPat(s3)
//        try? checkPatPlural(p1)
//        try? checkPatPlural(p2)
//        try? checkPatPlural(p3)
//        pl_v_user_defined.append((s1, p1, s2, p2, s3, p3))
//    }
//
//    func defAdj(singular: String, plural: String) throws {
//        try checkPat(singular)
//        try checkPatPlural(plural)
//        pl_adj_user_defined.append((singular, plural))
//    }
//
//    func defa(_ pattern: String) throws {
//        try checkPat(pattern)
//        A_a_user_defined.append((pattern, "a"))
//    }
//
//    func defan(_ pattern: String) throws {
//        try checkPat(pattern)
//        A_a_user_defined.append((pattern, "an"))
//    }
//
//    func udMatch(_ word: String, _ wordList: [String]) -> [String]? {
//        var i = wordList.count - 2
//        while i > -2 {
//            if var matches = "^\(wordList[i])$".matches(word) {
//                let replaced = wordList[i].replacingOccurrences(of: "$n", with: "\\n")
//                matches.append(replaced)
//                return matches
//            }
//            i -= 2
//        }
//        return nil
//    }
    
    func classical(_ args: [String: Bool]?) throws {
        let classicalModels = Rules.def_classical.keys.map { $0 }
        
        if let args = args {
            if let all = args["all"] {
                classical_dict = all ? Rules.all_classical : Rules.no_classical
            } else {
                try args.forEach { (k, v) in
                    if classicalModels.contains(k) {
                        classical_dict[k] = v
                    } else {
                        throw InflectError.unknownClassicalModeError
                    }
                }
            }
        } else {
            classical_dict = Rules.all_classical
        }
    }
    
    func num(count: Int, show: Bool) -> String {
        persistent_count = count
        return show ? "\(count)" : ""
    }
    
    func gender(_ gender: String) throws {
        /*
        set the gender for the singular of plural pronouns
        can be one of:
        'neuter'                ('they' -> 'it')
        'feminine'              ('they' -> 'she')
        'masculine'             ('they' -> 'he')
        'gender-neutral'        ('they' -> 'they')
        'feminine or masculine' ('they' -> 'she or he')
        'masculine or feminine' ('they' -> 'he or she')
        '*/
        if Rules.singular_pronoun_genders.contains(gender) {
            thegender = gender
        } else {
            throw InflectError.badGenderError
        }
    }
    
//    func nummo(_ matchObject: (Int, Bool)) -> String {
//        return num(count: matchObject.0, show: matchObject.1)
//    }
//
//    func plmo(_ matchObject: (String, Int)) -> String {
//        return plural(matchObject.0, count: matchObject.1)
//    }
//
//    func plNounMo() {
//
//    }
    
//    func inflect(_ text: String) {
//        let savePersistenceCount = persistent_count
//        let sections = text.split("(num\\([^)]*\\))")
//        var inflection = [String]()
//
//        for section in sections {
//            let (section, count) =
//        }
//    }
    
    func checkPatPlural(_ pattern: String) throws {
        return
    }
    
    func checkPat(_ pattern: String) throws {
        do {
            try pattern.validateExpression()
        } catch {
            throw InflectError.badUserDefinedPatternError
        }
    }
    
    func plural(_ text: String, count:Int) -> String {
        return ""
    }
    
    func postProcess(_ orig: String, inflected: String) -> String {
        var inflected = inflected
        if inflected.contains("|") {
            inflected = String(inflected.split(separator: "|")[classical_dict["all"] == true ? 1 : 0])
        }
        
        if orig == "I" {
            return inflected
        }
        
        if orig == orig.uppercased() {
            return inflected.uppercased()
        }
        
        if orig.first?.description == orig.first?.description.uppercased() {
            return String(format: "%@%@", inflected.first?.description ?? "", String(inflected.dropFirst()))
        }
        
        return inflected
    }
    
    func plural(_ text: String, count: String? = nil) -> String {
        let word = text.trim()
        let plural = postProcess(word, inflected: pl_special_adjective(word, count: count) ?? pl_special_verb(word, count: count) ?? plNoun(word, count: count))
        return plural
    }
    
    private func pl_special_adjective(_ word: String, count: String? = nil) -> String? {
        let count = getCount(count)
        if count == "1" { return word }
        // TODO: handle user defind adj
        // HANDLE KNOWN CASES
        if let mo = "^(\(Rules.pl_adj_special_keys))$".matches(word)?.first {
            return mo.lowercased()
        }
        
        // HANDLE POSSESSIVES
        if let mo = "^(\(Rules.pl_adj_poss_keys))$".matches(word)?.first {
            return mo.lowercased()
        }
        
        if let mo = "^(.*)'s?$".matches(word)?.first {
            let pl = pluralNoun(mo)
            let trailingS = pl.last == "s" ? "" : "s"
            return "\(pl)\(trailingS)"
        }
        
        return nil
    }
    
    private func pl_special_verb(_ word: String, count: String?) -> String? {
        if classical_dict["zero"] == true && Rules.pl_count_zero.contains(count?.lowercased() ?? "") {
            return nil
        }
        
        let count = getCount(count)
        if count == "1" {
            return word
        }
        
        // TODO: HANDLE USER-DEFINED VERBS
        // HANDLE IRREGULAR PRESENT TENSE (SIMPLE AND COMPOUND)
        let lowerword = word.lowercased()
        if let firstSeq = lowerword.split(separator: " ").first {
            let firstWord = String(firstSeq)
            
            if Rules.plverb_irregular_pres.keys.contains(firstWord) {
                return "\(Rules.plverb_irregular_pres[firstWord]!)\(word.suffix(word.count - firstWord.count))"
            }
            
            if Rules.plverb_irregular_non_pres.contains(firstWord) { return word }
            
            if firstWord.hasSuffix("n't") && Rules.plverb_irregular_pres.keys.contains(firstWord.first(dropping: 3)) {
                return "\(Rules.plverb_irregular_pres[firstWord.first(dropping: 3)]!)n't\(word.suffix(word.count - firstWord.count))"
            }
            
            if firstWord.hasSuffix("n't") { return word }
            
            if let _ = "^(\(Rules.plverb_special_s))$".matches(word) { return nil }
            
            if "\\s".matches(word) != nil { return nil }
            
            if lowerword == "quizzes" { return "quiz" }
            
            // HANDLE STANDARD 3RD PERSON (CHOP THE ...(e)s OFF SINGLE WORDS)
            if ["ches", "shes", "zzes", "sses"].contains(lowerword.last(4)) || lowerword.last(3) == "xes" { return word.first(dropping: 2) }
            
            if lowerword.last(3) == "ies" && word.count > 3 { return word.first(dropping: 3) + "y" }
            
            if Rules.pl_v_oes_oe.contains(lowerword) ||
                Rules.pl_v_oes_oe_endings_size4.contains(lowerword.last(4)) ||
                Rules.pl_v_oes_oe_endings_size5.contains(lowerword.last(5)) {
                return String(word.dropLast())
            }
            
            if lowerword.hasSuffix("oes") && word.count > 3 { return word.first(dropping: 2) }
            
            if let mo = "^(.*[^s])s$".matches(word), mo.count > 1 {
                return "\(Rules.plverb_ambiguous_pres[mo[0].lowercased()] ?? "")\(mo[1])"
            }
        }
        
        // OTHERWISE, A REGULAR VERB (HANDLE ELSEWHERE)
        return nil
    }
    
    func pluralNoun(_ text: String, count: String? = nil) -> String {
        let word = text.trim()
        return postProcess(word, inflected: plNoun(word, count: count))
    }
    
    private func plNoun(_ word: String, count: String? = nil) -> String {
        let count = getCount(count)
        if count == "1" { return word }
        // TODO: Handle user defined nouns
        
        if word == "" { return word }
        
        let lowecase = word.lowercased()
        
        if Rules.pl_sb_uninflected_complete.contains(lowecase) { return word }
        
        if Rules.pl_sb_uninflected_bysize.hasString(lowecase) {
            return word
        }
        
        if classical_dict["herd"] == true && Rules.pl_sb_uninflected_herd.contains(word) { return word }
        
        if let mo = "^(?:\(Rules.pl_sb_postfix_adj_stems))$".matches(word) {
            if mo.count >= 2 {
                return "\(plNoun(mo[0], count:"2"))\(mo[1]))"
            }
        }
        
        if lowecase.contains(" a ") || lowecase.contains("-a-") {
            if let mo = "^(?:\(Rules.pl_sb_prep_dual_compound))$".matches(word) {
                if mo.count >= 3 {
                    return "\(plNoun(mo[0], count:"2"))\(mo[1])\(plNoun(mo[2]))"
                }
            }
        }
        
        var lowerSplit = lowecase.split(separator: " ").map { String($0) }
        if lowerSplit.count >= 3 {
            for numword in 1..<lowerSplit.count-1 {
                if Rules.pl_prep_list_da.contains(lowerSplit[numword]) {
                    return " ".join(lowerSplit.prefix(numword-1) + [plNoun(lowerSplit[numword-1], count: "2")] + lowerSplit.suffix(from: numword))
                }
            }
        }
        
        lowerSplit = lowecase.split(separator: "-").map { String($0) }
        if lowerSplit.count >= 3 {
            for numword in 1..<lowerSplit.count-1 {
                if Rules.pl_prep_list_da.contains(lowerSplit[numword]) {
                    return " ".join(lowerSplit.prefix(numword-1) + [plNoun(lowerSplit[numword-1], count: "2") +
                        "-\(lowerSplit[numword])-"]) + " ".join(Array(lowerSplit.suffix(from: numword+1)))
                }
            }
        }
        
        for (k, v) in Rules.pl_pron_acc_keys_bysize {
            if v.contains(String(lowecase.dropFirst(lowecase.count-k))) {
                for (pk, pv) in Rules.pl_prep_bysize {
                    if pv.contains(String(lowecase.dropFirst(lowecase.count-pk))) {
                        if (lowecase.split(separator: " ").map { String($0) }) == [String(lowecase.prefix(pk)), String(lowecase.dropFirst(lowecase.count - k))] {
                            return lowecase.dropLast(k) + (Rules.pl_pron_acc[String(lowecase.dropFirst(lowecase.count - k))] ?? "")
                        }
                    }
                }
            }
        }
        
        if let pl = Rules.pl_pron_nom[lowecase] { return pl }
        
        if let pl = Rules.pl_pron_acc[lowecase] { return pl }
        
        //HANDLE ISOLATED IRREGULAR PLURALS
        lowerSplit = lowecase.split(separator: " ").map { String($0) }
        if let lastWord = lowerSplit.last {
            let lowerLastWord = lastWord.lowercased()
            var length = 0
            if Rules.plSbIrregularCaps.keys.contains(lastWord) {
                length = lastWord.count
                return "\(word.dropLast(length))\(Rules.plSbIrregularCaps[lastWord] ?? "")"
            }
            
            if Rules.plSbIrregular.keys.contains(lowerLastWord) {
                length = lastWord.count
                return "\(word.dropLast(length))\(Rules.plSbIrregular[lowerLastWord] ?? "")"
            }
            
            let lastTwoWord = " ".join(Array(lowerSplit.suffix(from: lowerSplit.count - 2))).lowercased()
            if Rules.plSbIrregularCompound.keys.contains(lastTwoWord) {
                length = lastTwoWord.count
                return "\(word.dropLast(length))\(Rules.plSbIrregularCompound[lastTwoWord] ?? "")"
            }
            
            if lowecase.dropFirst(lowecase.count - 3) == "quy" {
                return  word.dropLast(1) + "ies"
            }
            
            if lowecase.dropFirst(lowecase.count - 6) == "person" {
                if classical_dict["persons"] == true {
                    return word + "s"
                } else {
                    return word.dropLast(4) + "ople"
                }
            }
        }
        
        // HANDLE FAMILIES OF IRREGULAR PLURALS
        if lowecase.dropFirst(lowecase.count-3) == "man" {
            
            if Rules.pl_sb_U_man_mans_bysize.hasString(lowecase) {
                return word + "s"
            }
            
            if Rules.pl_sb_U_man_mans_caps_bysize.hasString(lowecase) {
                return word + "s"
            }
        }
        
        if lowecase.dropFirst(lowecase.count-5) == "mouse" {
            return "mice"
        }
        
        if lowecase.dropFirst(lowecase.count-5) == "louse" {
            return "lice"
        }
        
        if lowecase.dropFirst(lowecase.count-5) == "goose" {
            return "geese"
        }
        
        if lowecase.dropFirst(lowecase.count-5) == "tooth" {
            return "teeth"
        }
        
        if lowecase.dropFirst(lowecase.count-4) == "foot" {
            return "feet"
        }
        
        if lowecase == "die" {
            return "dice"
        }
        
        // HANDLE UNASSIMILATED IMPORTS
        if lowecase.dropFirst(lowecase.count-4) == "ceps" {
            return word
        }
        
        if lowecase.dropFirst(lowecase.count-4) == "zoon" {
            return word.dropLast(2) + "a"
        }
        
        if ["cis", "sis", "xis"].contains(String(lowecase.dropFirst(lowecase.count - 3))) {
            return word.dropLast(2) + "es"
        }
        
        for (lastlet, d, numend, post) in [
            ("h", Rules.pl_sb_U_ch_chs_bysize, 0, "s"),
            ("x", Rules.pl_sb_U_ex_ices_bysize, 2, "ices"),
            ("x", Rules.pl_sb_U_ix_ices_bysize, 2, "ices"),
            ("m", Rules.pl_sb_U_um_a_bysize, 2, "a"),
            ("s", Rules.pl_sb_U_us_i_bysize, 2, "i"),
            ("n", Rules.pl_sb_U_on_a_bysize, 2, "a"),
            ("a", Rules.plSbUAAeBysize, 0, "e")
            ]
        {
            if lowecase.last == lastlet.first {
                if d.hasString(lowecase) {
                    return word.dropLast(numend) + post
                }
            }
        }
        
        // HANDLE INCOMPLETELY ASSIMILATED IMPORTS
        if classical_dict["ancient"] == true {
            if lowecase.dropFirst(lowecase.count - 4) == "trix" {
                return word.dropLast(1) + "ces"
            }
            
            if ["eau", "ieu"].contains(lowecase.dropFirst(lowecase.count - 3)) {
                return word + "x"
            }
            
            if ["ynx", "inx", "anx"].contains(lowecase.dropFirst(lowecase.count - 3)) && word.count > 4 {
                return word.dropLast(1) + "ges"
            }
            
            for (lastlet, d, numend, post) in [
                ("n", Rules.pl_sb_C_en_ina_bysize, 2, "ina"),
                ("x", Rules.pl_sb_C_ex_ices_bysize, 2, "ices"),
                ("x", Rules.pl_sb_C_ix_ices_bysize, 2, "ices"),
                ("m", Rules.pl_sb_C_um_a_bysize, 2, "a"),
                ("s", Rules.pl_sb_C_us_i_bysize, 2, "i"),
                ("s", Rules.pl_sb_C_us_us_bysize, 0, ""),
                ("a", Rules.plSbCAAeBysize, 0, "e"),
                ("a", Rules.plSbCAAtaBysize, 0, "ta"),
                ("s", Rules.plSbCIsIdesBysize, 1, "des"),
                ("o", Rules.pl_sb_C_o_i_bysize, 1, "i"),
                ("n", Rules.pl_sb_C_on_a_bysize, 2, "a")
                ]
            {
                if lowecase.last == lastlet.last {
                    if d.hasString(lowecase) {
                        return word.dropLast(numend) + post
                    }
                }
            }
            
            for (d, numend, post) in [
                (Rules.pl_sb_C_i_bysize, 0, "i"),
                (Rules.pl_sb_C_im_bysize, 0, "im")
                ] {
                    if d.hasString(lowecase) {
                        return word.dropLast(numend) + post
                    }
            }
        }
                
        // HANDLE SINGULAR NOUNS ENDING IN ...s OR OTHER SILIBANTS
        if Rules.pl_sb_singular_s_complete.contains(lowecase) {
            return word + "es"
        }
        
        if Rules.pl_sb_singular_s_bysize.hasString(lowecase) {
            return word + "es"
        }
        
        if lowecase.dropFirst(lowecase.count-2) == "es" && word.first?.description == word.first?.description.uppercased() {
            return word + "es"
        }
        
        if lowecase.last == "z" {
            if Rules.plSbZZesBySize.hasString(lowecase) {
                return word + "s"
            }
            
            if lowecase.dropLast().last != "z" {
                return word + "zes"
            }
        }
        
        if lowecase.last(2) == "ze" {
            if Rules.plSbZeZesBySize.hasString(lowecase) {
                return word + "s"
            }
        }
        
        if ["ch", "sh", "zz", "ss"].contains(lowecase.last(2)) || lowecase.last == "x" {
            return word + "es"
        }
                
        // HANDLE ...f -> ...ves
        if ["elf", "alf", "olf"].contains(lowecase.last(3)) {
            return lowecase.dropLast() + "ves"
        }
        
        if lowecase.last(3) == "eaf" && lowecase.substring(-4, -3) != "d" {
            return lowecase.dropLast() + "ves"
        }
        
        if ["nife", "life", "wife"].contains(lowecase.last(4)) {
            return lowecase.first(dropping: 2) + "ves"
        }
        
        if lowecase.last(3) == "arf" {
            return lowecase.dropLast() + "ves"
        }
                
        // HANDLE ...y
        if lowecase.last == "y" {
            if "aeiou".contains(lowecase.substring(-2, -1)) || word.count == 1 {
                return word + "s"
            }
            
            if classical_dict["names"] == true {
                if word.first?.description == word.first?.description.uppercased() {
                    return word + "s"
                }
            }
            
            return word + "ies"
        }
                
        // HANDLE ...o
        if Rules.pl_sb_U_o_os_complete.contains(lowecase) {
            return word + "s"
        }
        
        if Rules.pl_sb_U_o_os_bysize.hasString(lowecase) {
            return word + "s"
        }
        
        if ["ao", "eo", "io", "oo", "uo"].contains(lowecase.last(2)) {
            return word + "s"
        }
        
        if lowecase.last == "o" {
            return word + "s"
        }
        
        // OTHERWISE JUST ADD ...s
        return word + "s"
    }
    
    private func getCount(_ count: String?) -> String {
        var finalCount = ""
        if let count = count {
            finalCount = Rules.pl_count_one.contains(count) || (classical_dict["zero"] == true && Rules.pl_count_zero.contains(count.lowercased())) ? "1" : "2"
        } else {
            finalCount = "\(persistent_count)"
        }
        
        return finalCount
    }
}
