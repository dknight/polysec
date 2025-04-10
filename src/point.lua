---@alias Point [number, number]

---Creates a new point.
---@param x number
---@param y number
---@return Point
local function new(x, y)
	return { x, y }
end

---Computes the distance between two points.
---@param p Point
---@param q Point
---@return number
local function distanceTo(p, q)
	local dx, dy = p[1] - q[1], p[2] - q[2]
	return math.sqrt(dx * dx + dy * dy)
end

---Checks that two points have same coordinates.
---@param p Point
---@param q Point
local function areEqual(p, q)
	return p[1] == q[1] and p[2] == q[2]
end

return {
	areEqual = areEqual,
	new = new,
	distanceTo = distanceTo,
}
