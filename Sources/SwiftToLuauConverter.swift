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

                if let functionCall = initializer.value.as(FunctionCallExprSyntax.self) {
                    _ = visit(functionCall)
                    return
                }

                if value.first == "\"" && value.last == "\"" && value.contains("\\(") {
                    value = convertStringLiteralToLuauInterpolation(value)
                }

                print("\(value)")
            }
        }
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let functionName = node.name.text
        let parameters = node.signature.parameterClause.parameters.map { param in
            param.secondName?.text ?? param.firstName.text
        }.joined(separator: ", ")

        print("function \(functionName)(\(parameters))")
        increaseIndent()

        return .visitChildren
    }

    override func visitPost(_ node: FunctionDeclSyntax) {
        decreaseIndent()
        print("end")
    }

    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        print(convertFunctionCall(node))

        return .skipChildren
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        print(convertEnum(node))

        return .skipChildren
    }

    // Switch statements
    override func visit(_ node: SwitchExprSyntax) -> SyntaxVisitorContinueKind {
        var currentNode: Syntax? = node.parent

        while let parent = currentNode {

            if let functionDecl = parent.as(FunctionDeclSyntax.self) {
                // Function declaration found
                let parameters = functionDecl.signature.parameterClause.parameters

                for parameter in parameters {
                    if let switchSubject = node.subject.as(DeclReferenceExprSyntax.self) {
                        if switchSubject.baseName.text == parameter.firstName.text {
                            let type = parameter.type.description
                            print(convertSwitch(node, inputType: type))
                            break
                        }
                    }
                }
                break
            }
            currentNode = parent.parent
        }

        return .skipChildren
    }
}
