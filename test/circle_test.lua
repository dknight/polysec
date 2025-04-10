local laura = require("laura")
local it = laura.it
local describe = laura.describe
local expect = laura.expect
local polysec = require("init")
local circle = polysec.circle
local rectangle = polysec.rectangle
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
		expect(circle.toList(c)).toBe({ 10, 20, 5 })
	end)

	describe("isCircle", function()
		it("should check that shape is circle", function()
			local c = circle.new(0, 5, 5)
			expect(circle.isCircle(c)).toEqual(true)
		end)

		it("should check that shape is circle", function()
			local c = circle.new(5, 0, 5)
			expect(circle.isCircle(c)).toEqual(true)
		end)

		it("should check that shape is circle", function()
			local c = circle.new(3, 4, 5)
			expect(circle.isCircle(c)).toEqual(true)
		end)

		it("should not be a circle", function()
			local r = rectangle.new(3, 4, 5, 6)
			expect(circle.isCircle(r)).toEqual(false)
		end)

		it("should not be a circle", function()
			expect(circle.isCircle({ 1, 1, 3 })).toEqual(false)
		end)
	end)

	describe("contains", function()
		it("should contain a ponit inside a circle", function()
			local p = point.new(1, 1)
			local c = circle.new(0, 1, 2)
			expect(circle.contains(c, p)).toEqual(true)
		end)

		it(
			"should contain a ponit inside (on the vorder) a circle",
			function()
				local p = point.new(12, 12)
				local c = circle.new(10, 10, 2)
				expect(circle.contains(c, p)).toEqual(true)
			end
		)

		it("should not contain a ponit inside a circle", function()
			local p = point.new(12, 13)
			local c = circle.new(10, 10, 2)
			expect(circle.contains(c, p)).toEqual(true)
		end)

		it("should not a ponit inside a circle", function()
			local p = point.new(10, 10)
			local c = circle.new(0, 1, 2)
			expect(circle.contains(c, p)).toEqual(false)
		end)
	end)
end)
