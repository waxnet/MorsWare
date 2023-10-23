esp = {}
do
    esp.tick = function()
        if config.esp.enabled then
            -- this has to be in the tick function to overwrite the outline applied by the game
            if config.esp.targets.loot then
                local loot = utilities.get_loot()

                if #loot > 0 then
                    -- outlines
                    if config.esp.config.outlines then
                        for _, item in pairs(loot) do
                            DrawBodyOutline(item, 1, 1, 0, 1)
                        end
                    end
                end
            end
        end
    end

    esp.draw = function()
        if config.esp.enabled then
            local origin_x, origin_y
            if config.esp.config.tracers then
                origin_x = (UiWidth() / 2)
                origin_y = UiHeight()
            end

            -- loot
            if config.esp.targets.loot then
                local loot = utilities.get_loot()

                -- check if there is any loot
                if #loot > 0 then
                    for _, item in pairs(loot) do
                        -- nametags
                        if config.esp.config.nametags then
                            local item_position = GetBodyTransform(item).pos
                            local item_x, item_y, distance = UiWorldToPixel(item_position)
                            local on_screen = distance > 0
                            
                            if on_screen then
                                UiPush()
                                    UiFont("bold.ttf", 10)
                                    UiTranslate(item_x, item_y)
                                    UiAlign("center middle")
                                    UiColor(1, 1, 0)
                                    UiText(GetTagValue(item, "interact"))
                                UiPop()
                            end
                        end

                        -- highlights
                        if config.esp.config.highlights then
                            DrawBodyHighlight(item, 1)
                        end

                        -- tracers
                        if config.esp.config.tracers then
                            local item_position = GetBodyTransform(item).pos
                            local item_x, item_y, item_d = UiWorldToPixel(item_position)
                            
                            if item_d > 0 then
                                local direction = (origin_x - item_x) > 0 and 1 or -1
                                
                                local side_a = math.abs(origin_x - item_x)
                                local side_b = math.abs(origin_y - item_y)
                                local side_c = math.sqrt((side_a ^ 2) + (side_b ^ 2))
                                
                                local angle = 0
                                if side_a > side_b then
                                    angle = (math.deg(math.asin(side_a / side_c)) * direction)
                                else
                                    angle = (math.deg(math.acos(side_b / side_c)) * direction)
                                end
                                
                                UiPush()
                                    UiTranslate(origin_x, origin_y)
                                    UiAlign("middle bottom")
                                    UiRotate(angle)
                                
                                    UiColor(1, 1, 0)
                                    
                                    UiRect(1, -(side_c * 2))
                                UiPop()
                            end
                        end
                    end
                end
            end

            -- entities
            if config.esp.targets.entities then
                local entities = utilities.get_entities()

                -- check if there are any entities
                if #entities > 0 then
                    for _, entity in pairs(entities) do
                        -- nametags
                        if config.esp.config.nametags then
                            local head_position = TransformToParentPoint(GetBodyTransform(entity["head"]), Vec(0, .2, 0))
                            local head_x, head_y, distance = UiWorldToPixel(head_position)
                            local on_screen = distance > 0
                            
                            if on_screen then
                                UiPush()
                                    UiFont("bold.ttf", 10)
                                    UiTranslate(head_x, head_y)
                                    UiAlign("bottom center")
                                    UiColor(1, 0, 0)
                                    UiText("ENEMY")
                                UiPop()
                            end
                        end

                        -- bones
                        if config.esp.config.bones then
                            -- head and torso positions
                            local head_min, head_max = GetBodyBounds(entity["head"])
                            local head_position = VecLerp(head_min, head_max, .5)

                            local torso_top = TransformToParentPoint(GetBodyTransform(entity["torso"]), Vec(0, .6, 0))
                            local torso_bottom = GetBodyTransform(entity["torso"]).pos

                            -- arms and hands positions
                            local left_arm_min, left_arm_max = GetBodyBounds(entity["left_arm"])
                            local left_arm_position = VecLerp(left_arm_min, left_arm_max, .5)

                            local right_arm_min, right_arm_max = GetBodyBounds(entity["right_arm"])
                            local right_arm_position = VecLerp(right_arm_min, right_arm_max, .5)

                            local left_hand_min, left_hand_max = GetBodyBounds(entity["left_hand"])
                            local left_hand_position = VecLerp(left_hand_min, left_hand_max, .5)

                            local right_hand_min, right_hand_max = GetBodyBounds(entity["right_hand"])
                            local right_hand_position = VecLerp(right_hand_min, right_hand_max, .5)

                            -- legs and feet positions
                            local left_leg_min, left_leg_max = GetBodyBounds(entity["left_leg"])
                            local left_leg_position = VecLerp(left_leg_min, left_leg_max, .5)

                            local right_leg_min, right_leg_max = GetBodyBounds(entity["right_leg"])
                            local right_leg_position = VecLerp(right_leg_min, right_leg_max, .5)

                            local left_foot_min, left_foot_max = GetBodyBounds(entity["left_foot"])
                            local left_foot_position = VecLerp(left_foot_min, left_foot_max, .5)

                            local right_foot_min, right_foot_max = GetBodyBounds(entity["right_foot"])
                            local right_foot_position = VecLerp(right_foot_min, right_foot_max, .5)

                            -- draw bones
                            DebugLine(torso_top, head_position, 1, 0, 0, 1)
                            DebugLine(torso_top, torso_bottom, 1, 0, 0, 1)

                            DebugLine(torso_top, left_arm_position, 1, 0, 0, 1)
                            DebugLine(torso_top, right_arm_position, 1, 0, 0, 1)
                            DebugLine(left_arm_position, left_hand_position, 1, 0, 0, 1)
                            DebugLine(right_arm_position, right_hand_position, 1, 0, 0, 1)

                            DebugLine(torso_bottom, left_leg_position, 1, 0, 0, 1)
                            DebugLine(torso_bottom, right_leg_position, 1, 0, 0, 1)
                            DebugLine(left_leg_position, left_foot_position, 1, 0, 0, 1)
                            DebugLine(right_leg_position, right_foot_position, 1, 0, 0, 1)
                        end

                        -- outlines
                        if config.esp.config.outlines then
                            for _, part in pairs(entity) do
                                DrawBodyOutline(part, 1, 0, 0, 1)
                            end
                        end

                        -- highlights
                        if config.esp.config.highlights then
                            for _, part in pairs(entity) do
                                DrawBodyHighlight(part, 1)
                            end
                        end

                        -- tracers
                        if config.esp.config.tracers then
                            local torso_position = GetBodyTransform(entity["torso"]).pos
                            local torso_x, torso_y, torso_d = UiWorldToPixel(torso_position)
                            
                            if torso_d > 0 then
                                local direction = (origin_x - torso_x) > 0 and 1 or -1
                                
                                local side_a = math.abs(origin_x - torso_x)
                                local side_b = math.abs(origin_y - torso_y)
                                local side_c = math.sqrt((side_a ^ 2) + (side_b ^ 2))
                                
                                local angle = 0
                                if side_a > side_b then
                                    angle = (math.deg(math.asin(side_a / side_c)) * direction)
                                else
                                    angle = (math.deg(math.acos(side_b / side_c)) * direction)
                                end
                                
                                UiPush()
                                    UiTranslate(origin_x, origin_y)
                                    UiAlign("middle bottom")
                                    UiRotate(angle)
                                
                                    UiColor(1, 0, 0)
                                    
                                    UiRect(1, -(side_c * 2))
                                UiPop()
                            end
                        end

                        -- boxes
                        if config.esp.config.boxes then
                            -- world positions
                            local head_min, head_max = GetBodyBounds(entity["head"])
                            local head_size = VecSub(head_max, head_min)
                            local head_position = GetBodyTransform(entity["head"]).pos
                            head_position[2] = (head_position[2] + (head_size[2] / 2) + .3)

                            local left_foot_min, left_foot_max = GetBodyBounds(entity["left_foot"])
                            local left_foot_size = VecSub(left_foot_max, left_foot_min)
                            local left_foot_position = GetBodyTransform(entity["left_foot"]).pos
                            left_foot_position[2] = (left_foot_position[2] - (left_foot_size[2] / 2) - .2)

                            local right_foot_min, right_foot_max = GetBodyBounds(entity["right_foot"])
                            local right_foot_size = VecSub(right_foot_max, right_foot_min)
                            local right_foot_position = GetBodyTransform(entity["right_foot"]).pos
                            right_foot_position[2] = (right_foot_position[2] - (right_foot_size[2] / 2) - .2)

                            -- screen positions
                            local upper_x, upper_y, upper_distance = UiWorldToPixel(head_position)
                            local lower_x, lower_y, lower_distance = nil, nil, nil
                            if left_foot_position[2] < right_foot_position[2] then
                                lower_x, lower_y, lower_distance = UiWorldToPixel(left_foot_position)
                            elseif left_foot_position[2] > right_foot_position[2] then
                                lower_x, lower_y, lower_distance = UiWorldToPixel(right_foot_position)
                            end

                            if (
                                (
                                    upper_distance ~= nil and
                                    lower_distance ~= nil
                                ) and (
                                    upper_distance > 0 and
                                    lower_distance > 0
                                )
                            ) then
                                -- data
                                local box_height = math.abs(upper_y - lower_y)
                                local box_width = (box_height / 1.5)
                                local box_x = (upper_x + (lower_x - upper_x) * .5)

                                local side_lines_y = nil
                                if upper_y < lower_y then
                                    side_lines_y = (upper_y + (box_height / 2))
                                elseif upper_y > lower_y then
                                    side_lines_y = (lower_y + (box_height / 2))
                                end

                                -- draw lines
                                UiPush()
                                    UiAlign("center middle")
                                    UiColor(1, 0, 0)

                                    UiPush()
                                        UiTranslate(box_x, upper_y)
                                        UiRect(box_width, 1)
                                    UiPop()
                                    UiPush()
                                        UiTranslate(box_x, lower_y)
                                        UiRect(box_width, 1)
                                    UiPop()

                                    UiPush()
                                        UiTranslate((box_x - (box_height / 3)), side_lines_y)
                                        UiRect(1, box_height)
                                    UiPop()
                                    UiPush()
                                        UiTranslate((box_x + (box_height / 3)), side_lines_y)
                                        UiRect(1, box_height)
                                    UiPop()
                                UiPop()
                            end
                        end
                    end
                end
            end
        end
    end
end
