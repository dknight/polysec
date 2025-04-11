local polysec = require("init")
local rectangle = polysec.rectangle
local polygon = polysec.polygon
local point = polysec.point
local circle = polysec.circle
local drag = false
local font = love.graphics.newFont(20)
local r = 8
local width, height, poly, circl, rect, p

function love.load()
	width, height = love.graphics.getDimensions()
	p = point.new(width / 2 + r / 2, height / 2 + r / 2)
	rect = rectangle.new(100, height / 2 - 100, 200, 200)
	local dh = height / 2 - 50
	poly = polygon.new(
		point.new(630, dh - 75),
		point.new(745, dh),
		point.new(690, dh + 100),
		point.new(620, dh + 50),
		point.new(530, dh + 100),
		point.new(500, dh - 50)
	)
	circl = circle.new(400, 480, 100)
	love.window.setTitle("Polysec demo: Point inside rectangle or polygon")
end

function love.update(dt)
	local x = love.mouse.getX()
	local y = love.mouse.getY()
	if drag then
		p[1] = x - r
		p[2] = y - r
	end
end

function love.draw()
	love.graphics.setFont(font)
	love.graphics.printf(
		"Drag a magenta point over the rectangle, circle or polygon.",
		0,
		20,
		width,
		"center"
	)
	local rMode, pMode, cMode = "line", "line", "line"
	if polysec.contain(rect, p) then
		rMode = "fill"
	end
	if polysec.contain(poly, p) then
		pMode = "fill"
	end
	if polysec.contain(circl, p) then
		cMode = "fill"
	end
	love.graphics.setLineWidth(3)
	love.graphics.setColor(0.5137, 0.2373, 0.9255)
	love.graphics.rectangle(rMode, rectangle.toList(rect))
	love.graphics.setColor(1, 0.7451, 0.0431)
	love.graphics.polygon(pMode, polygon.toList(poly))
	love.graphics.setColor(0.2275, 0.5255, 1)
	love.graphics.circle(cMode, circle.toList(circl))
	love.graphics.setColor(1, 0, 0.4314)
	love.graphics.circle("fill", p[1], p[2], r)
	love.graphics.reset()
end

function love.mousepressed()
	drag = true
end

function love.mousereleased()
	drag = false
end
