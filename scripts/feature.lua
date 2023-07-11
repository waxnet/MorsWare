feature = {}
do
    -- aimbot
    feature.aimbot = {
        enabled = registry.get_bool("aimbot.enabled"),
        config = {
            fov = {
                check = registry.get_bool("aimbot.config.fov.check"),
                draw = registry.get_bool("aimbot.config.fov.draw"),
                size = registry.get_int("aimbot.config.fov.size"),
                top_left = nil,
                bottom_right = nil,
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
    feature.esp = {
        enabled = registry.get_bool("esp.enabled"),
        config = {
            nametags = registry.get_bool("esp.config.nametags"),
            bones = registry.get_bool("esp.config.bones"),
            outlines = registry.get_bool("esp.config.outlines"),
            highlights = registry.get_bool("esp.config.highlights"),
            tracers = registry.get_bool("esp.config.tracers"),
        },
        targets = {
            entities = registry.get_bool("esp.targets.entities"),
            loot = registry.get_bool("esp.targets.loot"),
        },
        origin = nil,
    }
end
