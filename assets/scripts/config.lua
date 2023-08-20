config = {}
do
    -- update config
    config.update = function()
        config.aimbot = {
            enabled = registry.get_bool("aimbot.enabled"),
            config = {
                fov = {
                    check = registry.get_bool("aimbot.config.fov.check"),
                    draw = registry.get_bool("aimbot.config.fov.draw"),
                    size = registry.get_int("aimbot.config.fov.size"),
                    sides = registry.get_int("aimbot.config.fov.sides"),
                    rainbow = registry.get_string("aimbot.config.fov.rainbow"),
                },
                visibility = {
                    check = registry.get_bool("aimbot.config.visibility.check"),
                },
                distance = {
                    check = registry.get_bool("aimbot.config.distance.check"),
                    range = registry.get_int("aimbot.config.distance.range"),
                },
                target = registry.get_string("aimbot.config.target"),
            },
        }
    
        config.esp = {
            enabled = registry.get_bool("esp.enabled"),
            config = {
                nametags = registry.get_bool("esp.config.nametags"),
                bones = registry.get_bool("esp.config.bones"),
                outlines = registry.get_bool("esp.config.outlines"),
                highlights = registry.get_bool("esp.config.highlights"),
                tracers = registry.get_bool("esp.config.tracers"),
                boxes = registry.get_bool("esp.config.boxes"),
            },
            targets = {
                entities = registry.get_bool("esp.targets.entities"),
                loot = registry.get_bool("esp.targets.loot"),
            },
            origin = nil,
        }
    end

    -- aimbot
    config.aimbot = {
        enabled = registry.get_bool("aimbot.enabled"),
        config = {
            fov = {
                check = registry.get_bool("aimbot.config.fov.check"),
                draw = registry.get_bool("aimbot.config.fov.draw"),
                size = registry.get_int("aimbot.config.fov.size"),
                sides = registry.get_int("aimbot.config.fov.sides"),
                rainbow = registry.get_string("aimbot.config.fov.rainbow"),
            },
            visibility = {
                check = registry.get_bool("aimbot.config.visibility.check"),
            },
            distance = {
                check = registry.get_bool("aimbot.config.distance.check"),
                range = registry.get_int("aimbot.config.distance.range"),
            },
            target = registry.get_string("aimbot.config.target"),
        },
    }

    -- esp
    config.esp = {
        enabled = registry.get_bool("esp.enabled"),
        config = {
            nametags = registry.get_bool("esp.config.nametags"),
            bones = registry.get_bool("esp.config.bones"),
            outlines = registry.get_bool("esp.config.outlines"),
            highlights = registry.get_bool("esp.config.highlights"),
            tracers = registry.get_bool("esp.config.tracers"),
            boxes = registry.get_bool("esp.config.boxes"),
        },
        targets = {
            entities = registry.get_bool("esp.targets.entities"),
            loot = registry.get_bool("esp.targets.loot"),
        },
        origin = nil,
    }
end
