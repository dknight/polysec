---@enum (number) Kind
local Kind = {
	Rectangle = 0,
	Polygon = 1,
	Circle = 2,
}

---@type number A "very small" number.
local Epsilon = 1e-9

---@alias Shape Rectangle | Polygon | Circle | {kind: Kind}

---Create a metatable with a "kind" field to distinguish shapes easily
---created with PolySec
---@param kind Kind
---@return table
local function createMetaTableForKind(kind)
	return {
		__index = {
			kind = kind,
		},
	}
end

---Checks is the point inside a rectangle.
---@param sh Shape
---@return boolean
local function isPolygon(sh)
	return sh.kind == Kind.Polygon
end

---Checks that given shape is a circle.
---@param sh Shape
---@return boolean
local isCircle = function(sh)
	return sh.kind == Kind.Circle
end

---Checks that given shape is a orthogonal receives.
---@param sh Shape
---@return boolean
local function isRectangle(sh)
	return sh.kind == Kind.Rectangle
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
		return (x * x + y * y) <= s[3] * s[3]
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
	if math.abs(det) < Epsilon then
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
		return { x, y }
	end

	return nil
end

-- TODO comments annotations
local function overlapsRectRect(a, b)
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
local function overlapsPolyPoly(a, b)
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

---Checks overlap of 2 shapes.
---@param p Shape
---@param q Shape
---@return boolean, Shape | nil
local function overlap(p, q)
	if p.kind == Kind.Rectangle and q.kind == Kind.Rectangle then
		return overlapsRectRect(p, q)
	end
	if p.kind == Kind.Polygon and q.kind == Kind.Polygon then
		return overlapsPolyPoly(p, q)
	end
	return false
end

return {
	contain = contain,
	createMetaTableForKind = createMetaTableForKind,
	Kind = Kind,
	isPolygon = isPolygon,
	isRectangle = isRectangle,
	isCircle = isCircle,
	overlap = overlap,
	Epsilon = Epsilon,
}
