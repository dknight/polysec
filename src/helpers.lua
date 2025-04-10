local constant = require("constant")

---@param a number
---@param b number
---@return boolean
local closeTo = function(a, b)
	return a == b or math.abs(a - b) < constant.Epsilon
end

return {
	closeTo = closeTo,
}
