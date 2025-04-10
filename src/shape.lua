---@alias Shape Rectangle | Polygon | Circle | {kind: Kind}
---@alias Kind "rectangle" | "polygon" | "circle"

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
	createMetaTableForKind = createMetaTableForKind,
}
