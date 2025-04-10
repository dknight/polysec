local constant = require("src.constant")
local point = require("src.point")

local mt = require("shape").createMetaTableForKind("polygon")

---@alias Polygon Point[]

---Creates a new polygon.
---@param ... Point[]
---@return Polygon
local function new(...)
	local t = {}
	for _, p in ipairs(table.pack(...)) do
		t[#t + 1] = p
	end
	return setmetatable(t, mt)
end

---Adds point(s) to the polygon.
---@param poly Polygon
---@param ... Point[]
local function add(poly, ...)
	for _, p in ipairs(table.pack(...)) do
		poly[#poly + 1] = p
	end
end

---Converts polygon to the form of array [x1, y1, x2, y2, y3, y3, ..., xN, yN]
---@param poly Polygon
---@return number[]
local function toList(poly)
	local t = {}
	for _, p in ipairs(poly) do
		t[#t + 1] = p[1]
		t[#t + 1] = p[2]
	end
	return t
end

---Check if a point is inside a polygon `a` using the winding number method.
---Point is inside if the winding number is nonzero.
---@param a Polygon
---@param p Point
---@return boolean
local function contains(a, p)
	local windingNumber = 0

	for i = 1, #a do
		local v1 = a[i]
		local v2 = a[i % #a + 1]

		if v1[2] <= p[2] then
			if
				v2[2] > p[2]
				and (v2[1] - v1[1]) * (p[2] - v1[2])
					> (p[1] - v1[1]) * (v2[2] - v1[2])
			then
				windingNumber = windingNumber + 1
			end
		else
			if
				v2[2] <= p[2]
				and (v2[1] - v1[1]) * (p[2] - v1[2])
					< (p[1] - v1[1]) * (v2[2] - v1[2])
			then
				windingNumber = windingNumber - 1
			end
		end
	end

	return windingNumber ~= 0
end

---Compute the intersection of two line segments {`p1`, `p2`} and
---{`q1`, `q2`}. If segments are parallel or incongruent, it returns `nil`.
---@param p1 Point
---@param p2 Point
---@param q1 Point
---@param q2 Point
---@return Point | nil
local function intersects(p1, p2, q1, q2)
	local a1, b1, c1 =
		p2[2] - p1[2],
		p1[1] - p2[1],
		(p2[2] - p1[2]) * p1[1] + (p1[1] - p2[1]) * p1[2]
	local a2, b2, c2 =
		q2[2] - q1[2],
		q1[1] - q2[1],
		(q2[2] - q1[2]) * q1[1] + (q1[1] - q2[1]) * q1[2]

	local det = a1 * b2 - a2 * b1
	if math.abs(det) < constant.Epsilon then
		return nil
	end

	local x = (b2 * c1 - b1 * c2) / det
	local y = (a1 * c2 - a2 * c1) / det

	-- Ensure intersection is within both line segments
	if
		math.min(p1[1], p2[1]) <= x
		and x <= math.max(p1[1], p2[1])
		and math.min(p1[2], p2[2]) <= y
		and y <= math.max(p1[2], p2[2])
		and math.min(q1[1], q2[1]) <= x
		and x <= math.max(q1[1], q2[1])
		and math.min(q1[2], q2[2]) <= y
		and y <= math.max(q1[2], q2[2])
	then
		return point.new(x, y)
	end

	return nil
end

---Checks that two polygons are overlapping each other. If polygons do not
---overlap nil and false, they are returned; otherwise, clipped polygons and
---true are returned.
---@param a Polygon
---@param b Polygon
---@return Polygon | nil, boolean
local function overlaps(a, b)
	local t = {}

	for i = 1, #a do
		local p1 = a[i]
		local p2 = a[i % #a + 1]
		local clippedPolygon = {}

		for j = 1, #b do
			local q1 = b[j]
			local q2 = b[j % #b + 1]

			local inter = intersects(p1, p2, q1, q2)
			if inter then
				clippedPolygon[#clippedPolygon + 1] = inter
			end
		end

		if contains(b, p2) then
			clippedPolygon[#clippedPolygon + 1] = p2
		end

		for _, pt in ipairs(clippedPolygon) do
			t[#t + 1] = pt
		end
	end

	if #t > 0 then
		return t, true
	else
		return nil, false
	end
end

---Checks is the point inside a rectangle.
---@param shape Shape
---@return boolean
local function isPolygon(shape)
	return shape.kind == "polygon"
end

return {
	add = add,
	contains = contains,
	intersects = intersects,
	isPolygon = isPolygon,
	new = new,
	overlaps = overlaps,
	toList = toList,
}
