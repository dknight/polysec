local Kind = require("src.Kind")
local helpers = require("src.helpers")
local point = require("src.point")
local polygon = require("src.polygon")

local Epsilon = helpers.Epsilon

---@alias Shape Rectangle | Polygon | Circle | {kind: Kind}

---Checks is the point inside a rectangle.
---@param s Shape
---@return boolean
local function isPolygon(s)
	return s.kind == Kind.Polygon
end

---Checks that given shape is a circle.
---@param s Shape
---@return boolean
local isCircle = function(s)
	return s.kind == Kind.Circle
end

---Checks that given shape is a orthogonal receives.
---@param s Shape
---@return boolean
local function isRectangle(s)
	return s.kind == Kind.Rectangle
end

---Checks is the point inside a shape.
---For polygon using the winding number method.
---@param s Shape
---@param p Point
---@return boolean
local function contain(s, p)
	if isRectangle(s) then
		return p[1] >= s[1]
			and p[1] <= s[1] + s[3]
			and p[2] >= s[2]
			and p[2] <= s[2] + s[4]
	elseif isCircle(s) then
		local x = p[1] - s[1]
		local y = p[2] - s[2]
		return x * x + y * y <= s[3] * s[3]
	elseif isPolygon(s) then
		local windingNumber = 0
		for i = 1, #s do
			local v1 = s[i]
			local v2 = s[i % #s + 1]

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
	else
		return false
	end
end

---Compute the intersection of two line segments {p, q} and {s, t}.
---If segments are parallel or incongruent, it returns `nil`.
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

	local d = a1 * b2 - a2 * b1
	if math.abs(d) < Epsilon then
		return nil
	end

	local x = (b2 * c1 - b1 * c2) / d
	local y = (a1 * c2 - a2 * c1) / d

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
		return { x, y }
	end

	return nil
end

---Checks overlapping of two rectangles.
---TODO make return intersection rectangle
---@param a Rectangle
---@param b Rectangle
---@return boolean
local function rectangleRectangle(a, b)
	return a[1] < b[1] + b[3]
		and a[1] + a[3] > b[1]
		and a[2] < b[2] + b[4]
		and a[2] + a[4] > b[2]
end

---Checks that two polygons are overlapping each other. If polygons do not
---overlap nil and false, they are returned; otherwise, clipped polygons and
---true are returned.
---@param a Polygon
---@param b Polygon
---@return boolean, Polygon | nil
local function polygonPolygon(a, b)
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

		if contain(b, p2) then
			clippedPolygon[#clippedPolygon + 1] = p2
		end

		for _, pt in ipairs(clippedPolygon) do
			t[#t + 1] = pt
		end
	end

	if #t > 0 then
		return true, t
	else
		return false
	end
end

---Checks overlapping of rectangle and polygon.
---@param a Rectangle
---@param b Polygon
---@return boolean
local function rectanglePoly(a, b)
	local poly = polygon.new(
		point.new(a[1], a[2]),
		point.new(a[1], a[2] + a[4]),
		point.new(a[1] + a[3], a[2] + a[4]),
		point.new(a[1] + a[3], a[2])
	)
	return polygonPolygon(poly, b)
end

---Checks overlapping of rectangle and circle.
---@param a Rectangle
---@param b Circle
---@return boolean
local function rectangleCircle(a, b)
	local xMax, yMax = a[1] + a[3], a[2] + a[4]
	local xClosest = math.max(a[1], math.min(b[1], xMax))
	local yClosest = math.max(a[2], math.min(b[2], yMax))
	local dx, dy = xClosest - b[1], yClosest - b[2]
	return dx * dx + dy * dy <= b[3] * b[3]
end

---Checks overlapping of two circles.
---@param a Circle
---@param b Circle
---@return boolean
local function circleCircle(a, b)
	local dx, dy = b[1] - a[1], b[2] - a[2]
	return math.sqrt(dx * dx + dy * dy) <= a[3] + b[3]
end

---Checks that line intersect circle.
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param r Circle
---@return boolean
local function lineCircle(x1, y1, x2, y2, r)
	local ac = { r[1] - x1, r[2] - y1 }
	local ab = { x2 - x1, y2 - y1 }
	local ab2 = ab[1] * ab[1] + ab[2] * ab[2]
	local acab = ac[1] * ab[1] + ac[2] * ab[2]
	local t = acab / ab2
	t = t < 0 and 0 or t
	t = t > 1 and 1 or t
	local h = { (ab[1] * t + x1) - r[1], (ab[2] * t + y1) - r[2] }
	return h[1] * h[1] + h[2] * h[2] <= r[3] * r[3]
end

---Checks overlapping of polygon and circle.
---@param a Polygon
---@param b Circle
---@return boolean
local function polygonCircle(a, b)
	-- Check vertices
	for _, p in ipairs(a) do
		if contain(b, p) then
			return true
		end
	end
	-- Check lines
	for i = 2, #a, 1 do
		if lineCircle(a[i - 1][1], a[i - 1][2], a[i][1], a[i][2], b) then
			return true
		end
	end
	-- Checkt the last segment
	if lineCircle(a[1][1], a[1][2], a[#a][1], a[#a][2], b) then
		return true
	end
	-- Checks that circle inside polygon
	return contain(a, { b[1], b[2] })
end

---Checks overlap of 2 shapes.
---@param p Shape
---@param q Shape
---@return boolean, Shape?
local function overlap(p, q)
	if p.kind == Kind.Rectangle and q.kind == Kind.Rectangle then
		return rectangleRectangle(p, q)
	elseif p.kind == Kind.Polygon and q.kind == Kind.Polygon then
		return polygonPolygon(p, q)
	elseif p.kind == Kind.Rectangle and q.kind == Kind.Polygon then
		return rectanglePoly(p, q)
	elseif p.kind == Kind.Polygon and q.kind == Kind.Rectangle then
		return rectanglePoly(q, p)
	elseif p.kind == Kind.Circle and q.kind == Kind.Circle then
		return circleCircle(q, p)
	elseif p.kind == Kind.Rectangle and q.kind == Kind.Circle then
		return rectangleCircle(p, q)
	elseif p.kind == Kind.Circle and q.kind == Kind.Rectangle then
		return rectangleCircle(q, p)
	elseif p.kind == Kind.Polygon and q.kind == Kind.Circle then
		return polygonCircle(p, q)
	elseif p.kind == Kind.Circle and q.kind == Kind.Polygon then
		return polygonCircle(q, p)
	else
		return false
	end
end

return {
	Kind = Kind,
	contain = contain,
	isCircle = isCircle,
	isPolygon = isPolygon,
	isRectangle = isRectangle,
	overlap = overlap,
}
