---@enum (number) Kind
local Kind = {
	Rectangle = 0,
	Polygon = 1,
	Circle = 2,
}
---
---@alias Shape Rectangle | Polygon | Circle | {kind: Kind}

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
	Kind = Kind,
}
