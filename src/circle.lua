---@alias Circle number[]

local Circle = require("src.Kind").Circle
local mt = require("src.helpers").createMetaTableForKind(Circle)

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
---@return number, number, number
local function toList(circle)
	return circle[1], circle[2], circle[3]
end

return {
	new = new,
	toList = toList,
}
