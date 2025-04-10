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
		expect(rectangle.toList(r)).toBe({ 0, 0, 10, 10 })
	end)

	describe("Axis-aligned (orthogonal) rectangle", function()
		it("should collide two rectangles", function()
			local r1 = rectangle.new(0, 0, 100, 100)
			local r2 = rectangle.new(20, 20, 50, 50)
			expect(rectangle.overlaps(r1, r2)).toEqual(true)
		end)

		it("should not collide two rectangles", function()
			local r1 = rectangle.new(0, 0, 100, 100)
			local r2 = rectangle.new(200, 200, 100, 100)
			expect(rectangle.overlaps(r1, r2)).toEqual(false)
		end)

		it("should contain point inside", function()
			local p = point.new(120, 120)
			local r = rectangle.new(100, 100, 100, 100)
			expect(rectangle.contains(r, p)).toEqual(true)
		end)

		it("should not contain point inside", function()
			local p = point.new(-10, -10)
			local r = rectangle.new(0, 0, 100, 100)
			expect(rectangle.contains(r, p)).toEqual(false)
		end)

		it("should be a orthogonal rectangle", function()
			local r = rectangle.new(point.new(100, 100), point.new(200, 300))
			expect(rectangle.isRectangle(r)).toEqual(true)
		end)
	end)
end)
