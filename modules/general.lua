local M = {}

--self.clear_color = vmath.vector4(0, 0.185, 0.251, 1)

local camera = require "orthographic.camera"
--local rendercam = require "rendercam.rendercam"

M.hashedTable = {}

------------------ PROJECT GLOBALS ----------------------------------------
M.isMouseOnEnemy = false
math.piDouble = math.pi * 2
------------------ PROJECT GLOBALS ----------------------------------------

-- Adds to hashedTable, if already hashed simply return
-- string --> string to hash
function M.hashed ( string )
	if M.hashedTable[string] == nil then
		M.hashedTable[string] = hash(string)
	end
	return M.hashedTable[string]
end

function M.Sign(number)
    return (number > 0 and 1) or (number == 0 and 0) or -1
end

function M.CursorUpdateOrthograpic(action, action_id)
	-- Send worldPos to cursor
	local cursorScreen = vmath.vector3(action.x, action.y, 0)
	local cursorWorld = camera.screen_to_world(M.hashed("/camera"), cursorScreen)

	action.x = cursorWorld.x
	action.y = cursorWorld.y

	msg.post("/cursor#cursor", "input", { action_id = action_id, action = action })
end

--[[ function M.CursorUpdateRanderCam(action, action_id)
	-- Send worldPos to cursor
	local cursorWorld = rendercam.screen_to_world_2d(action.screen_x, action.screen_y, false, nil, false)

	action.x = cursorWorld.x
	action.y = cursorWorld.y

	if action_id == M.hashed("lc") then
		msg.post("/cursor#cursor", "input", { action_id = action_id, action = action })
	else
		msg.post("/cursor#cursor", "input", { action_id = nil, action = action })
	end
end ]]

function M.Find(table, value)
	for i,v in ipairs(table) do
		if v == value then
			return i
		end
	end
	print("Error: Cant Find Value. general.lua -> M.Find", value)
end

function M.Shift(table, input, isIndex)
	local index
	if isIndex then
		index = input
	else
		index = M.Find(table, input)
	end

	for i = index, #table do
		table[i] = table[i + 1]
	end
end

function M.LookAt (selfPos, lookPos, id)
	local angle = math.atan2(selfPos.x - lookPos.x , lookPos.y - selfPos.y)
	go.set_rotation(vmath.quat_rotation_z(angle), id)
end

function M.ScaleTo(selfPos, lookPos, size, id)
	local distance = vmath.vector3(1, vmath.length(lookPos - selfPos) / size, 1)
	go.set_scale(distance, id)
end

function M.LookScaleTo(selfPos, lookPos, size, id)
	M.LookAt(selfPos, lookPos, id)
	M.ScaleTo(selfPos, lookPos, size, id)
end

function M.Round(x)
  return x >= 0 and math.floor( x + 0.5) or math.ceil( x - 0.5)
end

function M.IdtoUrl(id)
	if id then
		return msg.url(nil, id, nil)
	else
		return false
	end
end

function M.EulerPozitive(euler)
	if euler < 0 then
		euler = euler + 360
	elseif euler > 360 then
		euler = euler - 360
	end
	return euler
end

function M.RadianPozitive(radian)
    if radian < 0 then
        radian = radian + math.piDouble
	elseif radian > math.piDouble then
		radian = radian - math.piDouble
    end
    return radian
end

return M