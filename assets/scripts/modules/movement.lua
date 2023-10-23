movement = {}
do
    movement.update = function()
        if config.movement.no_fall then
            local current_velocity = GetPlayerVelocity()
            local new_velocity = Vec(current_velocity[1], current_velocity[2], current_velocity[3])

            if config.movement.no_fall_mode == "glide" then
                if current_velocity[2] < -8 then
                    new_velocity[2] = -8
                end
            elseif config.movement.no_fall_mode == "reset" then
                if current_velocity[2] < -8 then
                    new_velocity[2] = 0
                end
            elseif config.movement.no_fall_mode == "teleport" then
                if current_velocity[2] <= -8 then
                    local player_transform = GetPlayerTransform()
                    local player_position = player_transform.pos
                    local player_rotation = player_transform.rot

                    local raycast_hit, raycast_distance = QueryRaycast(player_position, Vec(0, -1, 0), 100, .2)

                    if raycast_hit then
                        new_velocity[2] = 0

                        local new_player_position = Vec(player_position[1], (player_position[2] - raycast_distance), player_position[3])
                        SetPlayerTransform(Transform(new_player_position, player_rotation))
                    end
                end
            end

            SetPlayerVelocity(new_velocity)
        end
    end
end
