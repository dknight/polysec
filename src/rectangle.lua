---@alias Rectangle number[]

local Rectangle = require("src.Kind").Rectangle
local mt = require("src.helpers").createMetaTableForKind(Rectangle)

---Creates a new rectangle.
---@param x number
---@param y number
---@param w number
---@param h number
---@return Rectangle
---@overload fun(p: Point, q: Point): Rectangle
local function new(x, y, w, h)
	if type(x) == "table" and type(y) == "table" then
		return setmetatable({ x[1], x[2], y[1], y[2] }, mt)
	end
	return setmetatable({ x, y, w, h }, mt)
end

---Converts the rectangle to the array of numbers.
---@param rect Rectangle
---@return number, number, number, number
local function toList(rect)
	return rect[1], rect[2], rect[3], rect[4]
end

return {
	new = new,
	toList = toList,
}
