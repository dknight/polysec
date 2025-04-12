---@type number A "very small" number
local Epsilon = 1e-9

---@param a number
---@param b number
---@return boolean
local closeTo = function(a, b)
	return a == b or math.abs(a - b) < Epsilon
end

---Create a metatable with a "kind" field to distinguish shapes easily
---created with PolySec
---@param kind Kind
---@return table
local function createMetaTableForKind(kind)
	return {
		__index = {
			kind = kind,
		},
	}
end

return {
	Epsilon = Epsilon,
	closeTo = closeTo,
	createMetaTableForKind = createMetaTableForKind,
}
