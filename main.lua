-- scripts
#include "scripts/registry.lua"
#include "scripts/feature.lua"
#include "scripts/utilities.lua"

-- callbacks
function tick()
    -- esp
    do
        if feature.esp.enabled then
            -- update esp origin for tracers
            if feature.esp.config.tracers then
                feature.esp.origin = VecSub(GetCameraTransform().pos, Vec(0, 3, 0))
            end
        
            -- this has to be in the tick function to override the outline applied by the game
            if feature.esp.targets.loot then
                local loot = utilities.get_loot()

                if #loot > 0 then
                    for _, item in pairs(loot) do
                        -- outlines
                        if feature.esp.config.outlines then
                            DrawBodyOutline(item, 1, 1, 0, 1)
                        end
                    end
                end
            end
        end
    end
end

function update()
    -- check if player is in game
    if not utilities.is_playing() then
        return
    end

    -- aimbot
    do
        if feature.aimbot.enabled and InputDown("rmb") then
            local entities = utilities.get_entities()

            -- check if there are any entities
            if #entities > 0 then
                local closest_target_distance = math.huge
                local closest_target = nil

                -- get best target
                for _, entity in pairs(entities) do
                    -- set target
                    local target = entity["torso"]
                    if feature.aimbot.config.target == "head" then
                        target = entity["head"]
                    elseif feature.aimbot.config.target == "torso" then
                        target = entity["torso"]
                    end

                    -- check if target is visible
                    local is_visible = true
                    if feature.aimbot.config.visibility.check then
                        is_visible = IsBodyVisible(target, 1000)
                    end

                    if is_visible then
                        local target_position = GetBodyTransform(target).pos
                        local player_position = GetPlayerTransform().pos
                        local player_target_distance = VecLength(VecSub(player_position, target_position))
                        
                        -- check if target is in range
                        local in_range = true
                        if feature.aimbot.config.distance.check then
                            in_range = player_target_distance < feature.aimbot.config.distance.range
                        end

                        if in_range then
                            -- check if target is inside aimbot fov
                            local in_fov = true
                            if feature.aimbot.config.fov.check then
                                local target_x, target_y, _ = UiWorldToPixel(target_position)

                                in_fov = (
                                    target_x >= feature.aimbot.config.fov.top_left[1] and
                                    target_y >= feature.aimbot.config.fov.top_left[2] and
                                    target_x <= feature.aimbot.config.fov.bottom_right[1] and
                                    target_y <= feature.aimbot.config.fov.bottom_right[2]
                                )
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
                    local target_position = GetBodyTransform(closest_target).pos
                    local camera_position = GetCameraTransform().pos
                    local player_position = GetPlayerTransform().pos
                    local new_player_rotation = QuatLookAt(camera_position, target_position)

                    -- make player look at target and keep player velocity
                    local old_velocity = GetPlayerVelocity()
                    SetPlayerTransform(Transform(player_position, new_player_rotation), true)
                    SetPlayerVelocity(old_velocity)
                end
            end
        end
    end
end

function draw()
    -- check if player is in game
    if not utilities.is_playing() then
        return
    end

    -- get aimbot fov
    do
        if not (
            feature.aimbot.config.fov.top_left and
            feature.aimbot.config.fov.bottom_right
        ) then
            local screen_center_x = math.floor(UiWidth() / 2)
            local screen_center_y = math.floor(UiHeight() / 2)

            feature.aimbot.config.fov.top_left = {
                screen_center_x - feature.aimbot.config.fov.size,
                screen_center_y - feature.aimbot.config.fov.size
            }
            feature.aimbot.config.fov.bottom_right = {
                screen_center_x + feature.aimbot.config.fov.size,
                screen_center_y + feature.aimbot.config.fov.size
            }
        end
    end

    -- draw aimbot fov
    do
        if feature.aimbot.enabled and feature.aimbot.config.fov.draw then
            UiPush()
                UiColor(1, 1, 1)

                UiPush()
                    UiTranslate(feature.aimbot.config.fov.top_left[1], feature.aimbot.config.fov.top_left[2])
                    UiRect(feature.aimbot.config.fov.size * 2, 1)
                    UiRect(1, feature.aimbot.config.fov.size * 2)
                UiPop()

                UiPush()
                    UiTranslate(feature.aimbot.config.fov.bottom_right[1], feature.aimbot.config.fov.bottom_right[2])
                    UiRect(-feature.aimbot.config.fov.size * 2, 1)
                    UiTranslate(0, 1)
                    UiRect(1, -feature.aimbot.config.fov.size * 2 - 1)
                UiPop()
            UiPop()
        end
    end

    -- esp
    do
        if feature.esp.enabled then
            -- entities
            if feature.esp.targets.entities then
                local entities = utilities.get_entities()

                -- check if there are any entities
                if #entities > 0 then
                    for _, entity in pairs(entities) do
                        -- nametags
                        if feature.esp.config.nametags then
                            local target_position = TransformToParentPoint(GetBodyTransform(entity["head"]), Vec(0, .2, 0))
                            local target_x, target_y, distance = UiWorldToPixel(target_position)
                            local on_screen = distance > 0
                            
                            if on_screen then
                                UiPush()
                                    UiFont("bold.ttf", 10)
                                    UiTranslate(target_x, target_y)
                                    UiAlign("bottom center")
                                    UiColor(1, 0, 0)
                                    UiText("ENEMY")
                                UiPop()
                            end
                        end

                        -- bones
                        if feature.esp.config.bones then
                            -- head and torso positions
                            local head_min, head_max = GetBodyBounds(entity["head"])
                            local head_position = VecLerp(head_min, head_max, 0.5)

                            local torso_top = TransformToParentPoint(GetBodyTransform(entity["torso"]), Vec(0, .2, 0))
                            local torso_bottom = TransformToParentPoint(GetBodyTransform(entity["torso"]), Vec(0, -.4, 0))

                            -- arms and hands positions
                            local left_arm_min, left_arm_max = GetBodyBounds(entity["left_arm"])
                            local left_arm_position = VecLerp(left_arm_min, left_arm_max, 0.5)

                            local right_arm_min, right_arm_max = GetBodyBounds(entity["right_arm"])
                            local right_arm_position = VecLerp(right_arm_min, right_arm_max, 0.5)

                            local left_hand_min, left_hand_max = GetBodyBounds(entity["left_hand"])
                            local left_hand_position = VecLerp(left_hand_min, left_hand_max, 0.5)

                            local right_hand_min, right_hand_max = GetBodyBounds(entity["right_hand"])
                            local right_hand_position = VecLerp(right_hand_min, right_hand_max, 0.5)

                            -- legs and feet positions
                            local left_leg_min, left_leg_max = GetBodyBounds(entity["left_leg"])
                            local left_leg_position = VecLerp(left_leg_min, left_leg_max, 0.5)

                            local right_leg_min, right_leg_max = GetBodyBounds(entity["right_leg"])
                            local right_leg_position = VecLerp(right_leg_min, right_leg_max, 0.5)

                            local left_foot_min, left_foot_max = GetBodyBounds(entity["left_foot"])
                            local left_foot_position = VecLerp(left_foot_min, left_foot_max, 0.5)

                            local right_foot_min, right_foot_max = GetBodyBounds(entity["right_foot"])
                            local right_foot_position = VecLerp(right_foot_min, right_foot_max, 0.5)

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
                        if feature.esp.config.outlines then
                            DrawBodyOutline(entity["head"], 1, 0, 0, 1)
                            DrawBodyOutline(entity["torso"], 1, 0, 0, 1)
                            DrawBodyOutline(entity["left_arm"], 1, 0, 0, 1)
                            DrawBodyOutline(entity["right_arm"], 1, 0, 0, 1)
                            DrawBodyOutline(entity["left_hand"], 1, 0, 0, 1)
                            DrawBodyOutline(entity["right_hand"], 1, 0, 0, 1)
                            DrawBodyOutline(entity["left_leg"], 1, 0, 0, 1)
                            DrawBodyOutline(entity["right_leg"], 1, 0, 0, 1)
                            DrawBodyOutline(entity["left_foot"], 1, 0, 0, 1)
                            DrawBodyOutline(entity["right_foot"], 1, 0, 0, 1)
                        end

                        -- highlights
                        if feature.esp.config.highlights then
                            DrawBodyHighlight(entity["head"], 1)
                            DrawBodyHighlight(entity["torso"], 1)
                            DrawBodyHighlight(entity["left_arm"], 1)
                            DrawBodyHighlight(entity["right_arm"], 1)
                            DrawBodyHighlight(entity["left_hand"], 1)
                            DrawBodyHighlight(entity["right_hand"], 1)
                            DrawBodyHighlight(entity["left_leg"], 1)
                            DrawBodyHighlight(entity["right_leg"], 1)
                            DrawBodyHighlight(entity["left_foot"], 1)
                            DrawBodyHighlight(entity["right_foot"], 1)
                        end

                        -- tracers
                        if feature.esp.config.tracers then
                            DebugLine(feature.esp.origin, GetBodyTransform(entity["torso"]).pos, 1, 0, 0, 1)
                        end
                    end
                end
            end

            -- loot
            if feature.esp.targets.loot then
                local loot = utilities.get_loot()

                if #loot > 0 then
                    for _, item in pairs(loot) do
                        -- nametags
                        if feature.esp.config.nametags then
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
                        if feature.esp.config.highlights then
                            DrawBodyHighlight(item, 1)
                        end

                        -- tracers
                        if feature.esp.config.tracers then
                            DebugLine(feature.esp.origin, GetBodyTransform(item).pos, 1, 1, 0, 1)
                        end
                    end
                end
            end
        end
    end
end
