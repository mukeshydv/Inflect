//
//  Extensions.swift
//  Inflect
//
//  Created by Mukesh on 14/08/18.
//

extension Array {
    func appending(contentsOf sequence: Array) -> Array {
        var mutatingSelf = self
        mutatingSelf.append(contentsOf: sequence)
        return mutatingSelf
    }
}

extension String {
    func enclose() -> String {
        return "(?:\(self))"
    }
    
    func join(_ sequence: Array<String>) -> String {
        return sequence.joined(separator: self)
    }
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
