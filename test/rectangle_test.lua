local laura = require("laura")
local it = laura.it
local describe = laura.describe
local expect = laura.expect

local polysec = require("init")
local rectangle = polysec.rectangle
local point = polysec.point

describe("Rectangle", function()
	it("should create a new rectangle by coordinates", function()
		local r = rectangle.new(0, 0, 10, 10)
		expect(r).toBe({ 0, 0, 10, 10 })
	end)

	it("should create a new rectangle by points", function()
		local r = rectangle.new(point.new(0, 0), point.new(10, 10))
		expect(r).toBe({ 0, 0, 10, 10 })
	end)

	it("should convert a rectangle to list", function()
		local r = rectangle.new(point.new(0, 0), point.new(10, 10))
		expect({ rectangle.toList(r) }).toBe({ 0, 0, 10, 10 })
	end)
end)
