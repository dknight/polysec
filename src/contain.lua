---@module 'contain'

local helpers = require("src.helpers")
local isRectangle = helpers.isRectangle
local isCircle = helpers.isCircle
local isPolygon = helpers.isPolygon

---Checks is the point inside a shape.
---For polygon using the winding number method.
---@param s Shape
---@param p Point
---@return boolean
local function contain(s, p)
	if isRectangle(s) then
		return p[1] >= s[1]
			and p[1] <= s[1] + s[3]
			and p[2] >= s[2]
			and p[2] <= s[2] + s[4]
	elseif isCircle(s) then
		local x = p[1] - s[1]
		local y = p[2] - s[2]
		return x * x + y * y <= s[3] * s[3]
	elseif isPolygon(s) then
		local windingNumber = 0
		for i = 1, #s do
			local v1 = s[i]
			local v2 = s[i % #s + 1]

			if v1[2] <= p[2] then
				if
					v2[2] > p[2]
					and (v2[1] - v1[1]) * (p[2] - v1[2])
						> (p[1] - v1[1]) * (v2[2] - v1[2])
				then
					windingNumber = windingNumber + 1
				end
			else
				if
					v2[2] <= p[2]
					and (v2[1] - v1[1]) * (p[2] - v1[2])
						< (p[1] - v1[1]) * (v2[2] - v1[2])
				then
					windingNumber = windingNumber - 1
				end
			end
		end
		return windingNumber ~= 0
	else
		return false
	end
end

return contain
