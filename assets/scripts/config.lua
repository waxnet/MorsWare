config = {}
do
    config.refresh = function()
        config.aimbot = {
            enabled = registry.get_bool("aimbot.enabled"),
            config = {
                fov = {
                    check = registry.get_bool("aimbot.config.fov.check"),
                    draw = registry.get_bool("aimbot.config.fov.draw"),
                    size = registry.get_int("aimbot.config.fov.size", 200),
                    sides = registry.get_int("aimbot.config.fov.sides", 80),
                    rainbow = registry.get_string("aimbot.config.fov.rainbow", "disabled"),
                },
                visibility = {
                    check = registry.get_bool("aimbot.config.visibility.check"),
                },
                distance = {
                    check = registry.get_bool("aimbot.config.distance.check"),
                    range = registry.get_int("aimbot.config.distance.range", 500),
                },
                target = registry.get_string("aimbot.config.target", "head"),
            },
        }

        config.silentaim = {
            enabled = registry.get_bool("silentaim.enabled"),
            config = {
                fov = {
                    check = registry.get_bool("silentaim.config.fov.check"),
                    draw = registry.get_bool("silentaim.config.fov.draw"),
                    size = registry.get_int("silentaim.config.fov.size", 200),
                    sides = registry.get_int("silentaim.config.fov.sides", 80),
                    rainbow = registry.get_string("silentaim.config.fov.rainbow", "disabled"),
                },
                visibility = {
                    check = registry.get_bool("silentaim.config.visibility.check"),
                },
                distance = {
                    check = registry.get_bool("silentaim.config.distance.check"),
                    range = registry.get_int("silentaim.config.distance.range", 500),
                }
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

        config.exploits = {
            force_nv = registry.get_bool("exploits.force_nv"),
            force_nv_mode = registry.get_string("exploits.force_nv_mode", "pnv10t"),

            infinite_fuel = registry.get_bool("exploits.infinite_fuel"),

            instant_revive = registry.get_bool("exploits.instant_revive"),
        }
    end
end
