import Foundation

import SwiftParser

import SwiftSyntax

class SwiftToLuauConverter: SyntaxVisitor {
    var indentation: String = ""

    func increaseIndent() {
        indentation += "\t"
    }

    func decreaseIndent() {
        if indentation.count >= 1 {
            indentation = String(indentation.dropLast())
        }
    }

    // Variable Declaration
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        for binding in node.bindings {
            if let pattern = binding.pattern.as(IdentifierPatternSyntax.self),
                let initializer = binding.initializer
            {
                let variableName = pattern.identifier.text
                var value = initializer.value.description.trimmingCharacters(
                    in: .whitespacesAndNewlines)

                // Check if the value is a function call
                // if let functionCall = initializer.value.as(FunctionCallExprSyntax.self) {
                //     print("\(indentation)local \(variableName) = ", terminator: "")
                //     _ = visit(functionCall)
                //     return .skipChildren
                // }

                // If the initializer is a quoted string with Swift interpolation, convert it.
                if value.first == "\"" && value.last == "\"" && value.contains("\\(") {
                    value = convertStringLiteralToLuauInterpolation(value)
                }

                // print("\(indentation)local \(variableName) = \(value)")
                print("\(indentation)local \(variableName) = ", terminator: "")
            }
        }
        return .skipChildren
    }

    override func visitPost(_ node: VariableDeclSyntax) {
        for binding in node.bindings {
            if let pattern = binding.pattern.as(IdentifierPatternSyntax.self),
                let initializer = binding.initializer
            {
                var value = initializer.value.description.trimmingCharacters(
                    in: .whitespacesAndNewlines)

                // Check if the value is a function call
                if let functionCall = initializer.value.as(FunctionCallExprSyntax.self) {
                    _ = visit(functionCall)
                    return
                }

                // If the initializer is a quoted string with Swift interpolation, convert it.
                if value.first == "\"" && value.last == "\"" && value.contains("\\(") {
                    value = convertStringLiteralToLuauInterpolation(value)
                }
                // print("\(indentation)local \(variableName) = \(value)")
                print("\(value)")
            }
        }
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let functionName = node.name.text
        let parameters = node.signature.parameterClause.parameters.map { param in
            // Simplification: just use the first name ignoring external labels and types
            param.secondName?.text ?? param.firstName.text
        }.joined(separator: ", ")

        // Print the function header
        print("function \(functionName)(\(parameters))")
        increaseIndent()

        return .visitChildren
    }

    override func visitPost(_ node: FunctionDeclSyntax) {
        decreaseIndent()
        print("end")
    }

    // func walkFunctionBody(_ body: CodeBlockSyntax) {
    //     for stmt in body.statements {
    //         if let varDecl = stmt.item.as(VariableDeclSyntax.self) {
    //             _ = visit(varDecl)
    //         } else if let exprStmt = stmt.item.as(ExpressionStmtSyntax.self) {
    //             if let functionCall = exprStmt.expression.as(FunctionCallExprSyntax.self) {
    //                 _ = visit(functionCall)
    //             }
    //         } else if let returnStmt = stmt.item.as(ReturnStmtSyntax.self) {
    //             let expr =
    //                 returnStmt.expression?.description.trimmingCharacters(
    //                     in: .whitespacesAndNewlines) ?? ""
    //             print("\(indentation)return \(expr)")
    //         } else {
    //             let stmtText = stmt.description.trimmingCharacters(in: .whitespacesAndNewlines)
    //             print("\(indentation)\(stmtText)")
    //         }
    //     }
    // }

    // Process function call expressions to strip parameter labels
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        print(convertFunctionCall(node))

        return .skipChildren
    }

    // Enums
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        print(convertEnum(node))

        return .skipChildren
    }
}
