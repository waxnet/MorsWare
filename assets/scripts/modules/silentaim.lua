silentaim = {}
do
    silentaim.tick = function()
        if config.silentaim.enabled then
            -- get entities
            local entities = utilities.get_entities()

            -- tool body
            local tool_body = GetToolBody()
	
            -- offset data
            local tool_id = GetString("game.player.tool")
            local tool_name = GetString("game.tool." .. tool_id .. ".name")
            local tool_offset = offsets[tool_name]

            -- check if there are any entities
            if #entities > 0 and tool_body ~= 0 and tool_offset ~= nil then
                local closest_target_distance = math.huge
                local closest_target = nil

                -- get best target
                local player_position = GetPlayerTransform().pos
                
                for _, entity in pairs(entities) do
                    -- set target
                    local target = entity["torso"]

                    -- check if target is visible
                    local is_visible = true
                    if config.silentaim.config.visibility.check then
                        is_visible = IsBodyVisible(target, 1000, true)
                    end

                    if is_visible then
                        local target_position = GetBodyTransform(target).pos
                        local player_target_distance = VecLength(VecSub(player_position, target_position))
                        
                        -- check if target is in range
                        local in_range = true
                        if config.silentaim.config.distance.check then
                            in_range = player_target_distance < config.silentaim.config.distance.range
                        end

                        if in_range then
                            -- check if target is inside silentaim fov
                            local in_fov = true
                            if config.silentaim.config.fov.check then
                                local target_x, target_y, distance = UiWorldToPixel(target_position)
                                
                                if distance then
                                    in_fov = math.sqrt(
                                        (((UiWidth() / 2) - target_x) ^ 2) + (((UiHeight() / 2) - target_y) ^ 2)
                                    ) <= config.silentaim.config.fov.size
                                end
                            end

                            -- set closest target
                            if player_target_distance < closest_target_distance and in_fov then
                                closest_target_distance = player_target_distance
                                closest_target = target
                            end
                        end
                    end
                end

                -- check if a target has been found
                if closest_target then
                    -- get new tool position
                    local new_tool_position = TransformToParentPoint(GetCameraTransform(), Vec(tool_offset[1], .2, tool_offset[3]))
			
                    -- get target position
                    local target_bottom, target_top = GetBodyBounds(closest_target)
                    local target_position = VecAdd(VecLerp(target_bottom, target_top, .5), Vec(0, .6, 0))
                    
                    -- create new tool rotation
                    local new_rotation = QuatLookAt(new_tool_position, target_position)
                    
                    -- set tool position and rotation
                    SetBodyActive(tool_body, false)
                    SetBodyTransform(tool_body, Transform(new_tool_position, new_rotation))
                end
            end
        end
    end

    silentaim.draw = function()
        if config.silentaim.enabled and config.silentaim.config.fov.draw then
            local rgb_offset_range = math.floor(config.silentaim.config.fov.sides / 2)
            local rgb_offset_direction = true
            local rgb_offset = 0

            local rotation_offset = nil
            
            UiPush()
                -- default rotation, alignment and translation
                UiTranslate(UiWidth() / 2, UiHeight() / 2)
                UiAlign("center middle")
                
                for side = 1, config.silentaim.config.fov.sides do
                    UiPush()
                        -- set color
                        local r, g, b = .3, .3, 1

                        if config.silentaim.config.fov.rainbow == "normal" then
                            r, g, b = utilities.rgb()
                        elseif config.silentaim.config.fov.rainbow == "wave" then
                            if rgb_offset == rgb_offset_range then
                                rgb_offset_direction = false
                            end
                            if rgb_offset_direction then
                                r, g, b = utilities.rgb((rgb_offset * 4) / config.silentaim.config.fov.sides)
                                rgb_offset = (rgb_offset + 1)
                            else
                                r, g, b = utilities.rgb((rgb_offset * 4) / config.silentaim.config.fov.sides)
                                rgb_offset = (rgb_offset - 1)
                            end
                        end

                        UiColor(r, g, b)

                        -- rotate line
                        local new_rotation = (side * (360 / config.silentaim.config.fov.sides))
                        if rotation_offset == nil then
                            rotation_offset = new_rotation
                        end
                        UiRotate(new_rotation)

                        -- draw line
                        UiTranslate(0, -config.silentaim.config.fov.size)
                        UiRect(((math.rad(rotation_offset / 2) * config.silentaim.config.fov.size) * 2) + 4, 2)
                    UiPop()
                end
            UiPop()
        end
    end
end
