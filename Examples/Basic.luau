local x = 3
local y = 3
local z = x * y
local nilTest = nil
local stringA = "Hello"
local stringB = "World"
local stringC = `{stringA}, {stringB}!`
function test(testValue, multiplier, divisor)
	local innerVariable = 3
	return testValue * multiplier / divisor
end
local foo = test(3, 3, 3)
