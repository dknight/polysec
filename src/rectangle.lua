---@alias Rectangle [number, number, number, number]

local shape = require("shape")
local Rectangle = shape.Kind.Rectangle
local mt = shape.createMetaTableForKind(Rectangle)

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

---Checks axis-aligned rectangles for the collision.
---@param a Rectangle
---@param b Rectangle
---@return boolean
local function overlaps(a, b)
	return a[1] < b[1] + b[3]
		and a[1] + a[3] > b[1]
		and a[2] < b[2] + b[4]
		and a[2] + a[4] > b[2]
end

---Checks is the point inside a rectangle.
---@param rect Rectangle
---@param p Point
---@return boolean
local function contains(rect, p)
	return p[1] >= rect[1]
		and p[1] <= rect[1] + rect[3]
		and p[2] >= rect[2]
		and p[2] <= rect[2] + rect[4]
end

---Converts the rectangle to the array of numbers.
---@param rect Rectangle
---@return number[]
local function toList(rect)
	return { rect[1], rect[2], rect[3], rect[4] }
end

---Checks that given shape is a orthogonal receives.
---@param sh Shape
---@return boolean
local function isRectangle(sh)
	return sh.kind == Rectangle
end

return {
	contains = contains,
	isRectangle = isRectangle,
	new = new,
	overlaps = overlaps,
	toList = toList,
}
