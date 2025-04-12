local shape = require("src.shape")

return {
	circle = require("src.circle"),
	point = require("src.point"),
	polygon = require("src.polygon"),
	rectangle = require("src.rectangle"),

	shape = shape,
	overlap = shape.overlap,
	contain = shape.contain,

	isCircle = shape.isCircle,
	isPolygon = shape.isPolygon,
	isRectangle = shape.isRectangle,
}
