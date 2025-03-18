local polysec = require("init")
local rectangle = polysec.rectangle
local drag = false
local rect1, rect2
local font = love.graphics.newFont(20)
local width, height

function love.load()
	width, height = love.graphics.getDimensions()
	rect1 = rectangle.new(100, 100, 100, 100)
	rect2 = rectangle.new(width / 2 - 100, height / 2 - 100, 200, 200)
	love.window.setTitle("Polysec demo: Rectangles intersection")
end

function love.update(dt)
	local x = love.mouse.getX()
	local y = love.mouse.getY()
	if drag then
		rect1.x = x - rect1.w / 2
		rect1.y = y - rect1.h / 2
	end
end

function love.draw()
	love.graphics.setFont(font)
	love.graphics.printf(
		"Drag a smaller rectangle over the bigger one.",
		0,
		20,
		width,
		"center"
	)
	love.graphics.setLineWidth(3)
	love.graphics.setColor(0.5137, 0.2373, 0.9255)
	love.graphics.rectangle("line", rect2.x, rect2.y, rect2.w, rect2.h)
	local r1mode = "line"
	if rectangle.overlaps(rect1, rect2) then
		r1mode = "fill"
	end
	love.graphics.setColor(1, 0, 0.4314)
	love.graphics.rectangle(r1mode, rect1.x, rect1.y, rect1.w, rect1.h)
	love.graphics.reset()
end

function love.mousepressed()
	drag = true
end

function love.mousereleased()
	drag = false
end
