//
//  Inflect+String.swift
//  Inflect
//
//  Created by Mukesh on 23/08/18.
//

extension String {
    public var plural: String {
        return Inflect.default.plural(self)
    }
    
    public var pluralNoun: String {
        return Inflect.default.pluralNoun(self)
    }
    
    public var pluralVerb: String {
        return Inflect.default.pluralVerb(self)
    }
    
    public var singularNoun: String? {
        return try? Inflect.default.singularNoun(self)
    }
}
