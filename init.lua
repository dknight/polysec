local helpers = require("src.helpers")
local orthogonal = require("src.orthogonal")

return {
	circle = require("src.circle"),
	point = require("src.point"),
	polygon = require("src.polygon"),
	rectangle = require("src.rectangle"),

	overlap = require("src.overlap"),
	contain = require("src.contain"),

	isCircle = helpers.isCircle,
	isPolygon = helpers.isPolygon,
	isRectangle = helpers.isRectangle,

	orthogonal = orthogonal,
}
