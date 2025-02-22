var x = 3
let y = 3
let z = x * y
let nilTest = nil
let stringA = "Hello"
let stringB = "World"
let stringC = "\(stringA), \(stringB)!"

func test(testValue: Int, _ multiplier: Int, _ divisor: Int)
{
    let innerVariable = 3

    return testValue * multiplier / divisor
}

let foo = test(testValue: 3, 3, 3)
