aimbot = {}
do
    aimbot.update = function()
        if config.aimbot.enabled and InputDown("rmb") then
            local entities = utilities.get_entities()

            -- check if there are any entities
            if #entities > 0 then
                local closest_target_distance = math.huge
                local closest_target = nil

                -- get best target
                for _, entity in pairs(entities) do
                    -- set target
                    local target = entity["torso"]
                    if config.aimbot.config.target == "head" then
                        target = entity["head"]
                    elseif config.aimbot.config.target == "torso" then
                        target = entity["torso"]
                    end

                    -- check if target is visible
                    local is_visible = true
                    if config.aimbot.config.visibility.check then
                        is_visible = IsBodyVisible(target, 1000, true)
                    end

                    if is_visible then
                        local target_position = GetBodyTransform(target).pos
                        local player_position = GetPlayerTransform().pos
                        local player_target_distance = VecLength(VecSub(player_position, target_position))
                        
                        -- check if target is in range
                        local in_range = true
                        if config.aimbot.config.distance.check then
                            in_range = player_target_distance < config.aimbot.config.distance.range
                        end

                        if in_range then
                            -- check if target is inside aimbot fov
                            local in_fov = true
                            if config.aimbot.config.fov.check then
                                local target_x, target_y, distance = UiWorldToPixel(target_position)
                                
                                if distance then
                                    in_fov = math.sqrt(
                                        (((UiWidth() / 2) - target_x) ^ 2) + (((UiHeight() / 2) - target_y) ^ 2)
                                    ) <= config.aimbot.config.fov.size
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
                    -- get new player rotation
                    local player_position = GetPlayerTransform().pos
                    local new_player_rotation = QuatLookAt(GetCameraTransform().pos, GetBodyTransform(closest_target).pos)

                    -- make player look at target and keep player velocity
                    local old_velocity = GetPlayerVelocity()
                    SetPlayerTransform(Transform(player_position, new_player_rotation), true)
                    SetPlayerVelocity(old_velocity)
                end
            end
        end
    end

    aimbot.draw = function()
        if config.aimbot.enabled and config.aimbot.config.fov.draw then
            local rgb_offset_range = math.floor(config.aimbot.config.fov.sides / 2)
            local rgb_offset_direction = true
            local rgb_offset = 0

            local rotation_offset = nil
            
            UiPush()
                -- default rotation, alignment and translation
                UiTranslate(UiWidth() / 2, UiHeight() / 2)
                UiAlign("center middle")
                UiRotate(-45)
                
                for side = 1, config.aimbot.config.fov.sides do
                    UiPush()
                        -- set color
                        local r, g, b = 1, 1, 1

                        if config.aimbot.config.fov.rainbow == "normal" then
                            r, g, b = utilities.rgb()
                        elseif config.aimbot.config.fov.rainbow == "wave" then
                            if rgb_offset == rgb_offset_range then
                                rgb_offset_direction = false
                            end
                            if rgb_offset_direction then
                                r, g, b = utilities.rgb((rgb_offset * 4) / config.aimbot.config.fov.sides)
                                rgb_offset = (rgb_offset + 1)
                            else
                                r, g, b = utilities.rgb((rgb_offset * 4) / config.aimbot.config.fov.sides)
                                rgb_offset = (rgb_offset - 1)
                            end
                        end

                        UiColor(r, g, b)

                        -- rotate line
                        local new_rotation = (side * (360 / config.aimbot.config.fov.sides))
                        if rotation_offset == nil then
                            rotation_offset = new_rotation
                        end
                        UiRotate(new_rotation)

                        -- draw line
                        UiTranslate(0, -config.aimbot.config.fov.size)
                        UiRect(((math.rad(rotation_offset / 2) * config.aimbot.config.fov.size) * 2) + 4, 2)
                    UiPop()
                end
            UiPop()
        end
    end
end
