-- scripts
#include "assets/scripts/registry.lua"
#include "assets/scripts/config.lua"
#include "assets/scripts/utilities.lua"
#include "assets/scripts/menu.lua"

#include "assets/scripts/data/offsets.lua"

#include "assets/scripts/modules/aimbot.lua"
#include "assets/scripts/modules/silentaim.lua"
#include "assets/scripts/modules/esp.lua"
#include "assets/scripts/modules/exploits.lua"

-- callbacks
function init()
    config.refresh()
end

function tick()
    if not utilities.is_playing() then return end

    silentaim.tick()
    esp.tick()
    exploits.tick()
end

function update()
    if not utilities.is_playing() then return end

    aimbot.update()
    exploits.update()
end

function draw()
    if not utilities.is_playing() then return end

    esp.draw()
    aimbot.draw()
    silentaim.draw()

    -- draw menu
    local width = 500
    local height = 340

    menu.draw_menu(500, 340, 100, ((UiHeight() / 2) - (height / 2)))
end
