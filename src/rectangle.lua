---@alias Rectangle [number, number, number, number]

---Creates a new rectangle.
---@param x number
---@param y number
---@param w number
---@param h number
---@return Rectangle
---@overload fun(p: Point, q: Point): Rectangle
local function new(x, y, w, h)
	if type(x) == "table" and type(y) == "table" then
		return { x[1], x[2], y[1], y[2] }
	end
	return { x, y, w, h }
end

---Checks axis-aligned rectangles for the collision.
---@param a Rectangle
---@param b Rectangle
---@return boolean
local function overlaps(a, b)
	return a[1] < b[1] + b[3] and a[1] + a[3] > b[1] and a[2] < b[2] + b[4] and a[2] + a[4] > b[2]
end

---Checks is the point inside a rectangle.
---@param rect Rectangle
---@param p Point
---@return boolean
local function contains(rect, p)
	return p[1] >= rect[1] and p[1] <= rect[1] + rect[3] and p[2] >= rect[2] and p[2] <= rect[2] + rect[4]
end

---Converts the rectangle to the array of numbers.
---@param rect Rectangle
---@return number[]
local function toList(rect)
	return { rect[1], rect[2], rect[3], rect[4] }
end

return {
	new = new,
	overlaps = overlaps,
	contains = contains,
	toList = toList,
}
