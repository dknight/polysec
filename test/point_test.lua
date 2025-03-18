local laura = require("laura")
local it = laura.it
local describe = laura.describe
local expect = laura.expect
local polysec = require("init")
local point = polysec.point

describe("Point", function()
	it("should create a new point", function()
		local p = point.new(0, 0)
		expect(p).toBe({ 0, 0 })
	end)

	it("should have zero distance if points have same coordinates", function()
		local a = point.new(10, 10)
		local b = point.new(10, 10)
		expect(point.distanceTo(a, b)).toBeCloseTo(0)
	end)

	it("should calculate distance", function()
		local a = point.new(3, 2)
		local b = point.new(9, 7)
		expect(point.distanceTo(a, b)).toBeCloseTo(7.8102)
	end)

	it("should calculate distance for negative values", function()
		local a = point.new(3, -2)
		local b = point.new(9, -7)
		expect(point.distanceTo(a, b)).toBeCloseTo(7.8102)
	end)

	it("should calculate distance for ortogonal line", function()
		local a = point.new(0, 0)
		local b = point.new(0, 10)
		expect(point.distanceTo(a, b)).toBeCloseTo(10)
	end)
end)
