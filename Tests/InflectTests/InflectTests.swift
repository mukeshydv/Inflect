import XCTest
@testable import Inflect

final class InflectTests: XCTestCase {
    func testInflect() {
        let inflect = Inflect()
        
        if let file = Bundle(for: type(of: self)).path(forResource: "inflection", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: file, encoding: .utf8)
                let testCases = data.components(separatedBy: .newlines)
                for testCase in testCases {
                    if testCase.contains("TODO") { continue }
                    
                    let ge = testCase.components(separatedBy: "->")
                    if ge.count == 2 {
                        let givenSingular = ge[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        var givenPlural = ge[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        var comment = ""
                        if givenPlural.contains("#") {
                            let ec = givenPlural.components(separatedBy: "#")
                            if ec.count > 1 {
                                givenPlural = ec[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                comment = ec[1].trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                            }
                        }
                        
                        var plural = ""
                        
                        if comment.contains("verb") {
                            plural = inflect.pluralVerb(givenSingular)
                        } else if comment.contains("noun") {
                            plural = inflect.pluralNoun(givenSingular)
                        } else {
                            plural = inflect.plural(givenSingular)
                        }
                        
                        if givenPlural.contains("|") {
                            givenPlural = givenPlural.components(separatedBy: "|")[0]
                        }
                        
                        let result = plural == givenPlural
                        
                        XCTAssert(result, "Failed Plural for \(givenSingular): \(givenPlural)")
                        
                        if !comment.contains("verb") {
                            do {
                                let singular = try inflect.singularNoun(givenPlural)
                                XCTAssert(singular == givenSingular, "Failed Singular for \(givenPlural): \(givenSingular)")
                            } catch { }
                        }
                    }
                }
                
            } catch {
                XCTAssert(false, "Error reading file")
            }
        } else {
            XCTAssert(false, "File not found")
        }
    }

    func testExample() {
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
