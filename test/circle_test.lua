local laura = require("laura")
local it = laura.it
local describe = laura.describe
local expect = laura.expect

local polysec = require("init")
local circle = polysec.circle
local point = polysec.point

describe("Circle", function()
	it("should create a new circle", function()
		local c = circle.new(10, 20, 5)
		expect(c).toBe({ 10, 20, 5 })
	end)

	it("should create a new circle by point", function()
		local c = circle.new(point.new(10, 20), 5)
		expect(c).toBe({ 10, 20, 5 })
	end)

	it("should convert a circle to list", function()
		local c = circle.new(point.new(10, 20), 5)
		expect({ circle.toList(c) }).toBe({ 10, 20, 5 })
	end)
end)
