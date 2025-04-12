local polysec = require("init")
local rectangle = polysec.rectangle
local polygon = polysec.polygon
local circle = polysec.circle
local point = polysec.point
local drag = false
local testCircle, rect, poly, circl, width
local font = love.graphics.newFont(20)

function love.load()
	width = love.graphics.getDimensions()
	testCircle = circle.new(200, 200, 30)
	rect = rectangle.new(400, 100, 150, 150)
	poly = polygon.new(
		point.new(630, 400),
		point.new(670, 400),
		point.new(700, 450),
		point.new(670, 500),
		point.new(630, 500),
		point.new(600, 450)
	)
	circl = circle.new(200, 400, 80)
	love.window.setTitle("Polysec demo: circles intersection")
end

function love.update(dt) end

function love.draw()
	love.graphics.setFont(font)
	love.graphics.printf(
		"Drag a smaller magenta circle over the shapes.",
		0,
		20,
		width,
		"center"
	)
	love.graphics.setLineWidth(3)
	love.graphics.setColor(0.5137, 0.2373, 0.9255)
	love.graphics.rectangle("line", rectangle.toList(rect))
	love.graphics.setColor(0.9843, 0.3373, 0.0275)
	love.graphics.polygon("line", polygon.toList(poly))
	love.graphics.setColor(1, 0.7451, 0.0431)
	love.graphics.circle("line", circle.toList(circl))
	local r1mode = "line"
	if polysec.overlap(rect, testCircle) then
		r1mode = "fill"
	end
	-- TODO not implemented
	if polysec.overlap(poly, testCircle) then
		r1mode = "fill"
	end
	if polysec.overlap(circl, testCircle) then
		r1mode = "fill"
	end
	love.graphics.setColor(1, 0, 0.4314)
	love.graphics.circle(r1mode, circle.toList(testCircle))
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
		testCircle[1] = testCircle[1] + dx
		testCircle[2] = testCircle[2] + dy
	end
end
