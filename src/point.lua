---@alias Point{x: number, y: number}

---Creates a new point.
---@param x number
---@param y number
---@return Point
local function new(x, y)
	return { x = x, y = y }
end

---Computes the distance between two points.
---@param p Point
---@param q Point
---@return number
local function distanceTo(p, q)
	local dx, dy = p.x - q.x, p.y - q.y
	return math.sqrt(dx * dx + dy * dy)
end

return {
	new = new,
	distanceTo = distanceTo,
}
