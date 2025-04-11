local laura = require("laura")
local it = laura.it
local describe = laura.describe
local expect = laura.expect

local polysec = require("init")
local rectangle = polysec.rectangle
local circle = polysec.circle
local polygon = polysec.polygon
local point = polysec.point

describe("Shape", function()
	describe("Rectangle", function()
		describe("contain", function()
			it("should contain point inside", function()
				local p = point.new(120, 120)
				local r = rectangle.new(100, 100, 100, 100)
				expect(polysec.contain(r, p)).toEqual(true)
			end)

			it("should not contain point inside", function()
				local p = point.new(-10, -10)
				local r = rectangle.new(0, 0, 100, 100)
				expect(polysec.contain(r, p)).toEqual(false)
			end)
		end)

		describe("overlap", function()
			it("should collide two rectangles", function()
				local r1 = rectangle.new(0, 0, 100, 100)
				local r2 = rectangle.new(20, 20, 50, 50)
				expect(polysec.overlap(r1, r2)).toEqual(true)
			end)

			it("should not collide two rectangles", function()
				local r1 = rectangle.new(0, 0, 100, 100)
				local r2 = rectangle.new(200, 200, 100, 100)
				expect(polysec.overlap(r1, r2)).toEqual(false)
			end)
		end)

		describe("isRectangle", function()
			it("should be a orthogonal rectangle", function()
				local r =
					rectangle.new(point.new(100, 100), point.new(200, 300))
				expect(polysec.isRectangle(r)).toEqual(true)
			end)
		end)
	end)

	describe("Circle", function()
		describe("contains", function()
			it("should contain a ponit inside a circle", function()
				local p = point.new(1, 1)
				local c = circle.new(0, 1, 2)
				expect(polysec.contain(c, p)).toEqual(true)
			end)
			it(
				"should contain a ponit inside (on the vorder) a circle",
				function()
					local p = point.new(12, 12)
					local c = circle.new(10, 10, 2)
					expect(polysec.contain(c, p)).toEqual(true)
				end
			)
			it("should not contain a ponit inside a circle", function()
				local p = point.new(12, 13)
				local c = circle.new(10, 10, 2)
				expect(polysec.contain(c, p)).toEqual(true)
			end)
			it("should not a ponit inside a circle", function()
				local p = point.new(10, 10)
				local c = circle.new(0, 1, 2)
				expect(polysec.contain(c, p)).toEqual(false)
			end)
		end)

		describe("isCircle", function()
			it("should check that shape is circle", function()
				local c = circle.new(0, 5, 5)
				expect(polysec.isCircle(c)).toEqual(true)
			end)

			it("should check that shape is circle", function()
				local c = circle.new(5, 0, 5)
				expect(polysec.isCircle(c)).toEqual(true)
			end)

			it("should check that shape is circle", function()
				local c = circle.new(3, 4, 5)
				expect(polysec.isCircle(c)).toEqual(true)
			end)

			it("should not be a circle", function()
				local r = rectangle.new(3, 4, 5, 6)
				expect(polysec.isCircle(r)).toEqual(false)
			end)

			it("should not be a circle", function()
				expect(polysec.isCircle({ 1, 1, 3 })).toEqual(false)
			end)
		end)
	end)

	describe("Polygon", function()
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

		describe("contain", function()
			it("should have point inside", function()
				local p = point.new(150, 200)
				expect(polysec.contain(shapes[1].points, p)).toBeTruthy()
			end)
		end)

		describe("overlap", function()
			it("should overlap square and hexagon", function()
				local ok = polysec.overlap(shapes[1].points, shapes[4].points)
				expect(ok).toBeTruthy()
			end)

			it("should no overlap abstract and square-hole", function()
				local ok = polysec.overlap(shapes[2].points, shapes[3].points)
				expect(ok).toBeFalsy()
			end)

			it("should overlap some figures", function()
				local square = polygon.new(
					point.new(100, 150),
					point.new(200, 150),
					point.new(200, 250),
					point.new(100, 250)
				)
				local triangle = polygon.new(
					point.new(125, 125),
					point.new(62.5, 225),
					point.new(25, 125)
				)
				local _, poly = polysec.overlap(square, triangle)
				expect(poly).toBe({
					{ 109.375, 150.0 },
					{ 100.0, 165.0 },
					{ 100, 150 },
				})
			end)
		end)

		describe("isPolygon", function()
			it("should be a polygon", function()
				local poly = polygon.new({ 0, 0 }, { 100, 100 }, { 200, 200 })
				expect(polysec.isPolygon(poly)).toEqual(true)
			end)
		end)
	end)
end)
