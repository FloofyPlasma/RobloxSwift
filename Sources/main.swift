import Foundation
import SwiftParser
import SwiftSyntax

func main() {
    guard CommandLine.arguments.count == 2 else {
        print("Not enough arguments")
        return
    }

    let filePath = CommandLine.arguments[1]
    guard FileManager.default.fileExists(atPath: filePath) else {
        print("File doesn't exist at path: \(filePath)")
        return
    }

    guard let file = try? String(contentsOfFile: filePath) else {
        print("File isn't readable at path: \(filePath)")
        return
    }

    let _ = parseFile(in: file)
    // Outputs
    // print("################### PARSED ###################")
    // print(parsedFile)
    // print("################### END ###################")

}

func parseFile(in file: String) -> SourceFileSyntax {
    let sourceFile = Parser.parse(source: file)
    let visitor = SwiftToLuauConverter(viewMode: .all)
    visitor.walk(sourceFile)

    return sourceFile
}

main()
