local can_fire_timer = nil

guns = {}
do
    guns.can_fire = false

    guns.tick = function()
        -- tool body
        local tool_body = GetToolBody()
	
        -- offset data (this is just used to check if the tool is a gun)
        local tool_id = GetString("game.player.tool")
        local tool_name = GetString("game.tool." .. tool_id .. ".name")
        local tool_offset = offsets[tool_name]

        -- check if the player is holding a tool and if its a weapon
        if tool_body ~= 0 and tool_offset ~= nil then
            if can_fire_timer == nil then
                can_fire_timer = GetTime()
            end

            local current_timer = GetTime()
            if (current_timer - can_fire_timer) >= .5 then
                guns.can_fire = true
            else
                guns.can_fire = false
            end
        else
            can_fire_timer = nil
            guns.can_fire = false
        end
    end
end
