import XCTest
@testable import Inflect

final class InflectTests: XCTestCase {
    func testInflect() {
        
        let testCases = TestCases.testCases.components(separatedBy: .newlines)
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
                    plural = givenSingular.pluralVerb
                } else if comment.contains("noun") {
                    plural = givenSingular.pluralNoun
                } else {
                    plural = givenSingular.plural
                }
                
                if givenPlural.contains("|") {
                    givenPlural = givenPlural.components(separatedBy: "|")[0]
                }
                
                let result = plural == givenPlural
                
                XCTAssert(result, "Failed Plural for \(givenSingular): \(givenPlural)")
                
                if !comment.contains("verb") {
                    let singular = givenPlural.singularNoun
                    XCTAssert(singular == givenSingular, "Failed Singular for \(givenPlural): \(givenSingular)")
                }
            }
        }
    }
    
    static var allTests = [
        ("testInflect", testInflect)
    ]
}
