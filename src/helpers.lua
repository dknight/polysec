local Epsilon = require("src.Constant").Epsilon
local Kind = require("src.Kind")

---@param a number
---@param b number
---@return boolean
local closeTo = function(a, b)
	return a == b or math.abs(a - b) < Epsilon
end

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
return {
	Epsilon = Epsilon,
	closeTo = closeTo,
	createMetaTableForKind = createMetaTableForKind,
	isCircle = isCircle,
	isPolygon = isPolygon,
	isRectangle = isRectangle,
}
