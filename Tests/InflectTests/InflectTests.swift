import XCTest
@testable import Inflect

final class InflectTests: XCTestCase {
    func testInflect() {
        let inflect = Inflect()
        
        if let file = Bundle(for: type(of: self)).path(forResource: "inflection", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: file, encoding: .utf8)
                let testCases = data.components(separatedBy: .newlines)
                var failed = 0
                for testCase in testCases {
                    if testCase.contains("TODO") { continue }
                    
                    let ge = testCase.components(separatedBy: "->")
                    if ge.count == 2 {
                        let given = ge[0].trimmingCharacters(in: .whitespacesAndNewlines)
                        var expected = ge[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        var comment = ""
                        if expected.contains("#") {
                            let ec = expected.components(separatedBy: "#")
                            if ec.count > 1 {
                                expected = ec[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                comment = ec[1].trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                            }
                        }
                        
                        var plural = ""
                        
                        if comment.contains("verb") {
                            plural = inflect.pluralVerb(given)
                        } else if comment.contains("noun") {
                            plural = inflect.pluralNoun(given)
                        } else {
                            plural = inflect.plural(given)
                        }
                        
                        if expected.contains("|") {
                            expected = expected.components(separatedBy: "|")[0]
                        }
                        
                        let result = plural == expected
                        failed += result ? 0 : 1
                        
                        XCTAssert(result, "Failed for \(given): \(expected)")
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
