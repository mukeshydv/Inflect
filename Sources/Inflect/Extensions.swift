//
//  Extensions.swift
//  Inflect
//
//  Created by Mukesh on 14/08/18.
//
import Foundation

extension Array {
    func appending(contentsOf sequence: Array) -> Array {
        var mutatingSelf = self
        mutatingSelf.append(contentsOf: sequence)
        return mutatingSelf
    }
    
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension String {
    
    func enclose() -> String {
        return "(?:\(self))"
    }
    
    func join(_ sequence: Array<String>) -> String {
        return sequence.joined(separator: self)
    }
    
    func validateExpression() throws {
        let _ = try NSRegularExpression(pattern: self, options: .caseInsensitive)
    }
    
    func matches(_ string: String) -> [String]? {
        let regex = try? NSRegularExpression(pattern: self, options: .caseInsensitive)
        guard let result = regex?.matches(in: string, options: .reportProgress, range: NSRange(location: 0, length: string.count)).map ({ (string as NSString).substring(with: $0.range) }), result.count > 0 else {
            return nil
        }
        
        return result
    }
    
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func first(dropping count: Int) -> String {
        return String(dropLast(count))
    }
    
    func last(_ count: Int) -> String {
        return String(dropFirst(self.count - count))
    }
    
    func substring(_ from: Int, _ to: Int) -> String {
        var from = from
        var to = to
        
        if from < 0 {
            from = count - from
        }
        
        if to < 0 {
            to = count - to
        }
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
    
//    func split(_ regex: String) -> [String] {
//        return ranges(regex).map { String(self[$0]) }
//    }
    
//    func subn(_ regex: String, with string: String) {
//        var result: [Range<Index>] = []
//        var start = startIndex
//        while let range = range(of: regex, options: [.regularExpression, .caseInsensitive], range: start..<endIndex) {
//            result.append(range)
//            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
//        }
//
//        return replacingOccurrences(of: regex, with: string, options: [.caseInsensitive, .regularExpression], range: startIndex..<endIndex)
//    }
    
//    func ranges(_ regex: String) -> [Range<Index>] {
//        var result: [Range<Index>] = []
//        var start = startIndex
//        while let range = range(of: regex, options: [.regularExpression, .caseInsensitive], range: start..<endIndex) {
//            let prevRange = start..<range.lowerBound
//            result.append(prevRange)
//            result.append(range)
//            start = range.lowerBound < range.upperBound ? range.upperBound : index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
//        }
//        if start < endIndex {
//            result.append(start..<endIndex)
//        }
//        return result
//    }
}

extension Dictionary {
    static func +(left: [Key : Value], right: [Key :Value]) -> [Key: Value] {
        var dict = left
        for (k, v) in right { dict[k] = v }
        return dict
    }
}

extension Dictionary where Key == String, Value == Array<String> {
    func postfixEnclosed() -> [Key: String] {
        var dict = [Key: String] ()
        forEach {
            dict[$0.key] = ("|".join($0.value).enclose() + "(?=(?:-|\\s+)\($0.key))").enclose()
        }
        return dict
    }
}

extension Dictionary where Key == Int, Value == Set<String> {
    func hasString(_ string: String) -> Bool {
        for (k, v) in self {
            if v.contains(String(string.dropFirst(string.count-k))) { return true }
        }
        return false
    }
}

extension Dictionary where Value: Hashable {
    func reversedDict() -> [Value: Key] {
        return [Value: Key](uniqueKeysWithValues: self.map { ($1, $0) })
    }
}

extension Dictionary where Key == String, Value == [String: String] {
    func updateSiPron(with dict: [String: String], and key: String) -> [Key: Value] {
        var updatedDict = self
        updatedDict[key] = dict.reversedDict()
        return updatedDict
    }
}
