---@alias Rectangle{x: number, y: number, w: number, h: number}

---Creates a new rectangle.
---@param x number
---@param y number
---@param w number
---@param h number
---@return Rectangle
---@overload fun(p: Point, q: Point): Rectangle
local function new(x, y, w, h)
	if type(x) == "table" and type(y) == "table" then
		return { x = x.x, y = x.y, w = y.x, h = y.y }
	end
	return { x = x, y = y, w = w, h = h }
end

---Checks axis-aligned rectangles for the collision.
---@param a Rectangle
---@param b Rectangle
---@return boolean
local function overlaps(a, b)
	return a.x < b.x + b.w and a.x + a.w > b.x and a.y < b.y + b.h and a.y + a.h > b.y
end

---Checks is the point inside a rectangle.
---@param rect Rectangle
---@param p Point
---@return boolean
local function contains(rect, p)
	return p.x >= rect.x and p.x <= rect.x + rect.w and p.y >= rect.y and p.y <= rect.y + rect.h
end

---Converts the rectangle to the array of numbers.
---@param rect Rectangle
---@return number[]
local function toList(rect)
	return { rect.x, rect.y, rect.w, rect.h }
end

return {
	new = new,
	overlaps = overlaps,
	contains = contains,
	toList = toList,
}
