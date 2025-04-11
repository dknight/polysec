local polysec = require("init")
local polygon = polysec.polygon
local point = polysec.point
local font = love.graphics.newFont(20)
local width, drag

local function drawStar(cx, cy, r1, r2, n)
	local poly = polygon.new()
	local theta = math.pi / n

	for i = 0, (n * 2) - 1 do
		local angle = i * theta
		local r = (i % 2 == 0) and r1 or r2

		local x = cx + r * math.cos(angle)
		local y = cy + r * math.sin(angle)
		polygon.add(poly, point.new(x, y))
	end
	return poly
end

local shapes = {
	{
		name = "square",
		color = { 1, 0.7451, 0.0431 },
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
		color = { 0.9843, 0.3373, 0.0275 },
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
		color = { 1, 0, 0.4314 },
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
		color = { 0.5137, 0.2373, 0.9255 },
		points = polygon.new(
			point.new(630, 400),
			point.new(670, 400),
			point.new(700, 450),
			point.new(670, 500),
			point.new(630, 500),
			point.new(600, 450)
		),
		intersecting = false,
	},
	{
		name = "star",
		color = { 0.2275, 0.5176, 1 },
		points = drawStar(400, 300, 80, 40, 5),
		intersecting = false,
	},
}

local function fillPoly(poly)
	local triangles = love.math.triangulate(polygon.toList(poly.points))
	for _, tri in ipairs(triangles) do
		love.graphics.polygon("fill", tri)
	end
end

function love.load()
	width = love.graphics.getDimensions()
	love.window.setTitle("Polysec demo: Polygons ntersection")
end

function love.update(dt)
	-- not optimal, but ok for the demo
	for i in ipairs(shapes) do
		for j in ipairs(shapes) do
			local _, inter =
				polysec.overlap(shapes[i].points, shapes[j].points)
			if i ~= j and inter then
				shapes[i].intersecting = true
				break
			else
				shapes[i].intersecting = false
			end
		end
	end
end

function love.draw()
	love.graphics.setFont(font)
	love.graphics.printf(
		"Drag polygons over each other.",
		0,
		20,
		width,
		"center"
	)
	love.graphics.setLineWidth(3)
	for _, shape in ipairs(shapes) do
		love.graphics.setColor(table.unpack(shape.color))
		if shape.intersecting then
			fillPoly(shape)
		else
			love.graphics.polygon("line", polygon.toList(shape.points))
		end
	end
	love.graphics.reset()
end

function love.mousepressed(x, y)
	for _, shape in ipairs(shapes) do
		if polysec.contain(shape.points, point.new(x, y)) then
			drag = shape
		end
	end
end

function love.mousereleased()
	drag = nil
end

function love.mousemoved(_, _, dx, dy)
	if drag == nil then
		return
	end
	for _, p in ipairs(drag.points) do
		p[1] = p[1] + dx
		p[2] = p[2] + dy
	end
end
