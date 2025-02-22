import Foundation
import SwiftParser
import SwiftSyntax

func convertFunctionCall(_ node: FunctionCallExprSyntax) -> String {
    // Get the expression being called.
    let functionName = node.calledExpression.description.trimmingCharacters(
        in: .whitespacesAndNewlines)
    // Build a comma-separated list of arguments, ignoring any labels.
    let arguments = node.arguments.map { arg in
        arg.expression.description.trimmingCharacters(in: .whitespacesAndNewlines)
    }.joined(separator: ", ")

    return "\(functionName)(\(arguments))"
}
