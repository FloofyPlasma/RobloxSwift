import Foundation

func convertStringLiteralToLuauInterpolation(_ literal: String) -> String {
    guard literal.first == "\"" && literal.last == "\"" else {
        return literal
    }

    // Remove surrounding quotes
    let content = String(literal.dropFirst().dropLast())

    // Use regex to replace Swift interpolation patterns: \( ... )  =>  { ... }
    let interpolationRegex = /\\\((.+?)\)/
    var result = ""
    var currentIndex = content.startIndex

    for match in content.matches(of: interpolationRegex) {
        let matchRange = match.range

        // Append literal text before interpolation
        result += content[currentIndex..<matchRange.lowerBound]
        result += "{\(match.1)}"
        currentIndex = matchRange.upperBound
    }

    result += content[currentIndex..<content.endIndex]

    // Wrap the string in `` characters (specifies string interpolation in Luau)
    return "`\(result)`"
}
