local x = 3
local y = 3
local z = x * y
local nilTest = nil
local stringA = "Hello"
local stringB = "World"
local stringC = `{stringA}, {stringB}!`
function test(testValue, multiplier, divisor)
	local innerVariable = 3
end
local foo = test(3, 3, 3)
local Direction = table.freeze({
	north = "north",
	south = "south",
	east = "east",
	west = "west"
})
local ErrorCode = table.freeze({
	notFound = 404,
	unauthorized = 401
})
function enumTest(input)
	do
		local value = input
		if value == Direction.east then
			print("wowie east")
		elseif value == Direction.west or value == Direction.north then
			print("west or north")
		else
			print("not any of the above")
		end
	end
end
enumTest(Direction.east)
