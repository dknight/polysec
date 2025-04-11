local laura = require("laura")
local it = laura.it
local describe = laura.describe
local expect = laura.expect

local polysec = require("init")
local polygon = polysec.polygon

describe("Polygon", function()
	local testPoly = polygon.new({ 0, 0 }, { 100, 100 }, { 200, 200 })
	it("should create an empty polygon", function()
		local poly = polygon.new()
		expect(#poly).toEqual(0)
	end)

	it("should create a new polygon", function()
		expect(testPoly).toBe({
			{ 0, 0 },
			{ 100, 100 },
			{ 200, 200 },
		})
	end)

	it("should count points of the polygon", function()
		expect(#testPoly).toEqual(3)
	end)

	it("should add points to the polygon", function()
		local poly = polygon.new()
		polygon.add(poly, { 0, 0 })
		polygon.add(poly, { 100, 100 }, { 200, 200 })
		expect(poly).toBe(testPoly)
	end)

	it("should convert polygon to the list", function()
		expect(polygon.toList(testPoly)).toBe({ 0, 0, 100, 100, 200, 200 })
	end)

	it("should convert empty polygon to empty list", function()
		local poly = polygon.new()
		expect(polygon.toList(poly)).toBe({})
	end)
end)
