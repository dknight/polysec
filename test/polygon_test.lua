local laura = require("laura")
local it = laura.it
local describe = laura.describe
local expect = laura.expect
local polysec = require("init")
local polygon = polysec.polygon
local point = polysec.point

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

	describe("Intersection", function()
		local shapes = {
			{
				name = "square",
				color = { 1, 0, 0 },
				points = polygon.new(
					point.new(100, 150),
					point.new(200, 150),
					point.new(200, 250),
					point.new(100, 250)
				),
				intersecting = false,
			},
			{
				name = "square-hole",
				color = { 0, 1, 0 },
				points = polygon.new(
					point.new(600, 150),
					point.new(700, 150),
					point.new(700, 250),
					point.new(600, 250),
					point.new(625, 225),
					point.new(675, 225),
					point.new(675, 175),
					point.new(625, 175)
				),
				intersecting = false,
			},
			{
				name = "abstract",
				color = { 0, 0, 1 },
				points = polygon.new(
					point.new(100, 400),
					point.new(125, 425),
					point.new(100, 500),
					point.new(125, 475),
					point.new(175, 475),
					point.new(200, 500),
					point.new(200, 400)
				),
				intersecting = false,
			},
			{
				name = "hexagon",
				color = { 1, 1, 0 },
				points = polygon.new(
					point.new(230, 200),
					point.new(270, 200),
					point.new(300, 250),
					point.new(270, 300),
					point.new(230, 300),
					point.new(200, 250)
				),
				intersecting = false,
			},
		}

		it("should have point inside", function()
			local p = point.new(150, 200)
			expect(polygon.contains(shapes[1].points, p)).toBeTruthy()
		end)

		it("should overlap square and hexagon", function()
			local _, ok = polygon.overlaps(shapes[1].points, shapes[4].points)
			expect(ok).toBeTruthy()
		end)

		it("should no overlap abstract and square-hole", function()
			local _, ok = polygon.overlaps(shapes[2].points, shapes[3].points)
			expect(ok).toBeFalsy()
		end)

		it("should overlap some figures", function()
			local square =
				polygon.new(point.new(100, 150), point.new(200, 150), point.new(200, 250), point.new(100, 250))
			local triangle = polygon.new(point.new(125, 125), point.new(62.5, 225), point.new(25, 125))
			local poly = polygon.overlaps(square, triangle)
			expect(poly).toBe({
				{ 109.375, 150.0 },
				{ 100.0, 165.0 },
				{ 100, 150 },
			})
		end)
	end)
end)
