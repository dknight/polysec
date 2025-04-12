---@module 'orthogonal'

---Checks that point is inside orthogonal rectangle.
---@param r Rectangle
---@param p Point
---@return boolean
local function contain(r, p)
	return p[1] >= r[1]
		and p[1] <= r[1] + r[3]
		and p[2] >= r[2]
		and p[2] <= r[2] + r[4]
end

---Checks overlapping of two orthogonal rectangles.
---@param a Rectangle
---@param b Rectangle
---@return boolean
local function overlap(a, b)
	return a[1] < b[1] + b[3]
		and a[1] + a[3] > b[1]
		and a[2] < b[2] + b[4]
		and a[2] + a[4] > b[2]
end

return {
	contain = contain,
	overlap = overlap,
}
