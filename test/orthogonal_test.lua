local laura = require("laura")
local it = laura.it
local describe = laura.describe
local expect = laura.expect

local polysec = require("init")
local orthogonal = polysec.orthogonal
local point = polysec.point

describe("Orthogonal rectangle", function()
	describe("contain", function()
		it("should contain point inside", function()
			local p = point.new(120, 120)
			local r = orthogonal.rectangle.new(100, 100, 100, 100)
			expect(polysec.orthogonal.contain(r, p)).toEqual(true)
		end)

		it("should not contain point inside", function()
			local p = point.new(-10, -10)
			local r = orthogonal.rectangle.new(0, 0, 100, 100)
			expect(polysec.orthogonal.contain(r, p)).toEqual(false)
		end)
	end)

	describe("overlap", function()
		it("should overlap two orthogonal rectangles", function()
			local r1 = orthogonal.rectangle.new(0, 0, 100, 100)
			local r2 = orthogonal.rectangle.new(20, 20, 50, 50)
			expect(polysec.orthogonal.overlap(r1, r2)).toEqual(true)
		end)

		it("should not overlap two orthogonal rectangles", function()
			local r1 = orthogonal.rectangle.new(0, 0, 100, 100)
			local r2 = orthogonal.rectangle.new(200, 200, 100, 100)
			expect(polysec.orthogonal.overlap(r1, r2)).toEqual(false)
		end)
	end)

	describe("isRectangle", function()
		it("should be a orthogonal rectangle", function()
			local r = orthogonal.rectangle.new(
				point.new(100, 100),
				point.new(200, 300)
			)
			expect(polysec.isRectangle(r)).toEqual(true)
		end)
	end)
end)
