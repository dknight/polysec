local Epsilon = require("src.shape").Epsilon

---@param a number
---@param b number
---@return boolean
local closeTo = function(a, b)
	return a == b or math.abs(a - b) < Epsilon
end

return {
	closeTo = closeTo,
}
