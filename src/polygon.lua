---@module 'polygon'

local Polygon = require("src.Kind").Polygon
local mt = require("src.helpers")._createMetaTableForKind(Polygon)

---@alias Polygon Point[]

---Creates a new polygon.
---@param ... Point
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
---@param ... Point
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

return {
	add = add,
	new = new,
	toList = toList,
}
