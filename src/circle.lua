---@alias Circle [number, number, number]

local mt = require("shape").createMetaTableForKind("circle")

---Creates a new point.
---@param x number
---@param y number
---@param r number
---@return Circle
---@overload fun(p: Point, r: number): Circle
local function new(x, y, r)
	if type(x) == "table" then
		return setmetatable({ x[1], x[2], y }, mt)
	end
	return setmetatable({ x, y, r }, mt)
end

---Converts the circle to the array of numbers. This method is done for
---the consistency only.
---@param circle Circle
---@return number[]
local function toList(circle)
	return circle
end

---Checks is the point inside a circle.
---@param circle Circle
---@param p Point
---@return boolean
local function contains(circle, p)
	local x = p[1] - circle[1]
	local y = p[2] - circle[2]
	local r = circle[3] * circle[3]
	return (x * x + y * y) <= r * r
end

---Checks that given shape is a circle.
---@param shape Shape
---@return boolean
local isCircle = function(shape)
	return shape.kind == "circle"
end

return {
	contains = contains,
	isCircle = isCircle,
	new = new,
	toList = toList,
}
