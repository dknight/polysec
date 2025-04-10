local laura = require("laura")
local it = laura.it
local describe = laura.describe
local expect = laura.expect
local closeTo = require("helpers").closeTo

describe("helpers", function()
	describe("closeTo", function()
		it("should compare numbers", function()
			expect(closeTo(42, 42)).toEqual(true)
			expect(closeTo(1 / 9, 1 / 9)).toEqual(true)
			expect(closeTo(1 / 9, 0.11111111111111)).toEqual(true)
			expect(closeTo(0.11111111111111, 0.11111111111111)).toEqual(true)
			expect(closeTo(0, 0)).toEqual(true)
			expect(closeTo(0, -0)).toEqual(true)
			expect(closeTo(math.huge, math.huge)).toEqual(true)
			expect(closeTo(1e-6, 0.000001)).toEqual(true)
			expect(closeTo(0.00001, 0.000001)).toEqual(false)
		end)
	end)
end)
