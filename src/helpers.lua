---@module 'helpers'

local Epsilon = require("src.Constant").Epsilon
local Kind = require("src.Kind")

---Helper function for float equality comparison.
---@param a number
---@param b number
---@return boolean
local closeTo = function(a, b)
	return a == b or math.abs(a - b) < Epsilon
end

---Create a metatable with a "kind" field to distinguish shapes easily
---created with PolySec.
---@param kind Kind
---@return table
local function _createMetaTableForKind(kind)
	return {
		__index = {
			kind = kind,
		},
	}
end

---Checks that shape is a polygon.
---@param s Shape
---@return boolean
local function isPolygon(s)
	return s.kind == Kind.Polygon
end

---Checks that shape is a circle.
---@param s Shape
---@return boolean
local isCircle = function(s)
	return s.kind == Kind.Circle
end

---Checks that shape is a rectangle.
---@param s Shape
---@return boolean
local function isRectangle(s)
	return s.kind == Kind.Rectangle
end

return {
	_createMetaTableForKind = _createMetaTableForKind,
	closeTo = closeTo,
	isCircle = isCircle,
	isPolygon = isPolygon,
	isRectangle = isRectangle,
}
