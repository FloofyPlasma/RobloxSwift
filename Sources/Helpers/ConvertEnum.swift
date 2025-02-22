import Foundation
import SwiftParser
import SwiftSyntax

func convertEnum(_ enumDecl: EnumDeclSyntax) -> String {
    let enumName = enumDecl.name.text
    var cases: [String] = []

    for member in enumDecl.memberBlock.members {
        if let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) {
            for element in caseDecl.elements {
                let caseName = element.name.text
                if let rawValue = element.rawValue?.value {
                    cases.append("\(caseName) = \(rawValue.description)")
                } else {
                    cases.append("\(caseName) = \"\(caseName)\"")
                }
            }
        }
    }

    let luaTable = cases.joined(separator: ",\n\t")
    return "local \(enumName) = table.freeze({\n\t\(luaTable)\n})"
}
