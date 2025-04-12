local helpers = require("src.helpers")
local rectangle = require("src.rectangle")
local orthogonal = require("src.orthogonal")

return {
	circle = require("src.circle"),
	point = require("src.point"),
	polygon = require("src.polygon"),
	rectangle = rectangle,

	overlap = require("src.overlap"),
	contain = require("src.contain"),

	isCircle = helpers.isCircle,
	isPolygon = helpers.isPolygon,
	isRectangle = helpers.isRectangle,

	orthogonal = {
		rectangle = rectangle,
		contain = orthogonal.contain,
		overlap = orthogonal.overlap,
	},
}
