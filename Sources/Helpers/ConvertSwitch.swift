import Foundation
import SwiftParser
import SwiftSyntax

func convertSwitch(_ switchStmt: SwitchExprSyntax, inputType: String) -> String {
    let expr = switchStmt.subject.description
    var cases: [String] = []
    var defaultCase: String? = nil

    for caseStmt in switchStmt.cases {
        if let caseClause = caseStmt.as(SwitchCaseSyntax.self),
           let caseLabel = caseClause.label.as(SwitchCaseLabelSyntax.self) {
            
            let conditions = caseLabel.caseItems.map { item -> String in
                let pattern = item.pattern.description
                // Reference the enum case directly without any prefix
                return "value == \(inputType)\(pattern)"
            }.joined(separator: " or ")

            let body = caseClause.statements
                .map { "\t\t" + $0.description.trimmingCharacters(in: .whitespacesAndNewlines) }
                .joined(separator: "\n\t")

            cases.append("elseif \(conditions) then\n\t\(body)")
        } else if let caseClause = caseStmt.as(SwitchCaseSyntax.self),
                  caseClause.label.as(SwitchDefaultLabelSyntax.self) != nil {
            
            let body = caseClause.statements
                .map { "\t\t" + $0.description.trimmingCharacters(in: .whitespacesAndNewlines) }
                .joined(separator: "\n\t")

            defaultCase = "else\n\t\(body)"
        }
    }

    // Ensure first condition uses "if" instead of "elseif"
    if let firstCase = cases.first {
        cases[0] = firstCase.replacingOccurrences(of: "elseif", with: "if", options: .anchored)
    }

    return "\tdo\n\t\tlocal value = \(expr)\n\t\t\(cases.joined(separator: "\n\t\t"))\n\t\t\(defaultCase ?? "")\n\t\tend\n\tend"
}
