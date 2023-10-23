utilities = {}
do
    -- get all loaded entities
    utilities.get_entities = function()
        local entities = {}

        for _, torso in pairs(FindBodies("Torso", true)) do
            -- check if entity is not dead and if the torso is above ground
            if (
                not HasTag(torso, "dead")
            ) then
                local torso_id = GetTagValue(torso, "gore_id") -- entity id
                local entity = {} -- entity structure

                -- head and torso
                for _, head in pairs(FindBodies("Head", true)) do
                    local head_id = GetTagValue(head, "gore_id")

                    if head_id == torso_id then
                        -- add body parts to entity structure
                        entity["head"] = head
                        entity["torso"] = torso
                        break
                    end
                end

                -- arms and hands
                for _, left_arm in pairs(FindBodies("LARM", true)) do
                    local left_arm_id = GetTagValue(left_arm, "gore_id")

                    if left_arm_id == torso_id then
                        -- add body part to entity structure
                        entity["left_arm"] = left_arm
                        break
                    end
                end
                for _, left_hand in pairs(FindBodies("LLARM", true)) do
                    local left_hand_id = GetTagValue(left_hand, "gore_id")

                    if left_hand_id == torso_id then
                        -- add body part to entity structure
                        entity["left_hand"] = left_hand
                        break
                    end
                end
                for _, right_arm in pairs(FindBodies("RARM", true)) do
                    local right_arm_id = GetTagValue(right_arm, "gore_id")

                    if right_arm_id == torso_id then
                        -- add body part to entity structure
                        entity["right_arm"] = right_arm
                        break
                    end
                end
                for _, right_hand in pairs(FindBodies("RRARM", true)) do
                    local right_hand_id = GetTagValue(right_hand, "gore_id")

                    if right_hand_id == torso_id then
                        -- add body part to entity structure
                        entity["right_hand"] = right_hand
                        break
                    end
                end

                -- legs and feet
                for _, left_leg in pairs(FindBodies("LLEG", true)) do
                    local left_leg_id = GetTagValue(left_leg, "gore_id")

                    if left_leg_id == torso_id then
                        -- add body part to entity structure
                        entity["left_leg"] = left_leg
                        break
                    end
                end
                for _, left_foot in pairs(FindBodies("LLLEG", true)) do
                    local left_foot_id = GetTagValue(left_foot, "gore_id")

                    if left_foot_id == torso_id then
                        -- add body part to entity structure
                        entity["left_foot"] = left_foot
                        break
                    end
                end
                for _, right_leg in pairs(FindBodies("RLEG", true)) do
                    local right_leg_id = GetTagValue(right_leg, "gore_id")

                    if right_leg_id == torso_id then
                        -- add body part to entity structure
                        entity["right_leg"] = right_leg
                        break
                    end
                end
                for _, right_foot in pairs(FindBodies("RRLEG", true)) do
                    local right_foot_id = GetTagValue(right_foot, "gore_id")

                    if right_foot_id == torso_id then
                        -- add body part to entity structure
                        entity["right_foot"] = right_foot
                        break
                    end
                end
                
                -- check if the entity body parts are all existing and valid
                local is_entity_valid = true

                for _, part in pairs(entity) do
                    if part ~= nil then
                    local part_position = GetBodyTransform(part).pos

                        if part_position[2] < -3 then
                            is_entity_valid = false
                            break
                        end
                    end
                end

                if is_entity_valid then
                    local center_point = GetBodyTransform(entity["torso"]).pos
                    local highest_distance = 0

                    for _, part in pairs(entity) do
                        if part ~= nil then
                            local part_position = GetBodyTransform(part).pos
                            local distance = VecLength(VecSub(center_point, part_position))
                            
                            if distance > highest_distance then
                                highest_distance = distance
                            end
                        end
                    end

                    if highest_distance > 1.5 then
                        is_entity_valid = false
                    end
                end

                -- add entity to entities table
                if not (
                    IsBodyJointedToStatic(entity["left_foot"]) and
                    IsBodyJointedToStatic(entity["right_foot"])
                ) and is_entity_valid then
                    table.insert(entities, entity)
                end
            end
        end

        return entities
    end

    -- get all loaded loot
    utilities.get_loot = function()
        local loot = FindBodies("Loot", true)
        local items = {}

        for _, item in pairs(loot) do
            local item_position = GetBodyTransform(item).pos

            if (
                not HasTag(item, "invisible") and
                IsHandleValid(item) and
                not IsBodyBroken(item) and
                item_position[2] > -3
            ) then
                table.insert(items, item)
            end
        end

        return items
    end

    -- check if player is in game
    utilities.is_playing = function()
        if HasKey("level.roadgen") then
            return true
        end
        return false
    end

    -- get rainbow colors
    utilities.rgb = function(time_offset)
        local time_offset = time_offset or 0
		local current_time = (GetTime() + time_offset)
        
		return math.sin(current_time) * 0.5 + 0.5, math.sin(current_time + 2) * 0.5 + 0.5, math.sin(current_time + 4) * 0.5 + 0.5
	end

    -- find item index inside table
    utilities.item_index = function(table, value)
        local value_index = nil
        
        for index, item in pairs(table) do
            if value == item then
                value_index = index
                break
            end
        end

        return value_index
    end
end
