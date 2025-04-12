local polysec = require("init")
local rectangle = polysec.rectangle
local polygon = polysec.polygon
local point = polysec.point
local drag = false
local rect1, rect2, poly, width, height
local font = love.graphics.newFont(20)

function love.load()
	width, height = love.graphics.getDimensions()
	rect1 = rectangle.new(100, 100, 100, 100)
	rect2 = rectangle.new(width / 2 - 100, height / 2 - 100, 200, 200)
	poly = polygon.new(
		point.new(630, 400),
		point.new(670, 400),
		point.new(700, 450),
		point.new(670, 500),
		point.new(630, 500),
		point.new(600, 450)
	)
	love.window.setTitle("Polysec demo: Rectangles intersection")
end

function love.update(dt) end

function love.draw()
	love.graphics.setFont(font)
	love.graphics.printf(
		"Drag a smaller rectangle over the shapes.",
		0,
		20,
		width,
		"center"
	)
	love.graphics.setLineWidth(3)
	love.graphics.setColor(0.5137, 0.2373, 0.9255)
	love.graphics.rectangle("line", rectangle.toList(rect2))
	love.graphics.setColor(0.9843, 0.3373, 0.0275)
	love.graphics.polygon("line", polygon.toList(poly))
	local r1mode = "line"
	if polysec.overlap(rect2, rect1) then
		r1mode = "fill"
	end
	if polysec.overlap(poly, rect1) then
		r1mode = "fill"
	end
	love.graphics.setColor(1, 0, 0.4314)
	-- love.graphics.rectangle(r1mode, rectangle.toList(rect1))
	love.graphics.rectangle(r1mode, rect1[1], rect1[2], 100, 100)
	love.graphics.reset()
end

function love.mousepressed()
	drag = true
end

function love.mousereleased()
	drag = false
end

function love.mousemoved(_, _, dx, dy)
	if drag then
		rect1[1] = rect1[1] + dx
		rect1[2] = rect1[2] + dy
	end
end
