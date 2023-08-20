-- scripts
#include "assets/scripts/registry.lua"
#include "assets/scripts/config.lua"
#include "assets/scripts/utilities.lua"
#include "assets/scripts/menu.lua"

#include "assets/scripts/modules/esp.lua"
#include "assets/scripts/modules/aimbot.lua"

-- callbacks
function tick()
    esp.tick()
end

function update()
    -- check if player is in game
    if not utilities.is_playing() then
        return
    end

    aimbot.update()
end

function draw()
    -- check if player is in game
    if not utilities.is_playing() then
        return
    end

    esp.draw()
    aimbot.draw()

    -- draw menu
    local width = 500
    local height = 340

    menu.draw_menu(500, 340, 100, ((UiHeight() / 2) - (height / 2)))
end
