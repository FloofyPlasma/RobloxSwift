var x = 3
let y = 3
let z = x * y
let nilTest = nil
let stringA = "Hello"
let stringB = "World"
let stringC = "\(stringA), \(stringB)!"
func test(testValue: Int, _ multiplier: Int, _ divisor: Int) {
    let innerVariable = 3

    return testValue * multiplier / divisor
}
let foo = test(testValue: 3, 3, 3)
enum Direction {
    case north
    case south
    case east
    case west
}
enum ErrorCode: Int {
    case notFound = 404
    case unauthorized = 401
}
func enumTest(input: Direction) {
    switch input
    {
    case .east:
        print("wowie east")
    case .west, .north:
        print("west or north")
    default:
        print("not any of the above")
    }
}

enumTest(input: Direction.east)
