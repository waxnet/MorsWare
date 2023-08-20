#include "assets/scripts/utilities.lua"
#include "assets/scripts/menu.lua"
#include "assets/scripts/registry.lua"
#include "assets/scripts/config.lua"

function draw()
    -- background image
    UiImage("assets/images/background.png", 0, 0, UiWidth(), UiHeight())

    -- draw menu
    local width = 500
    local height = 340

    menu.draw_menu(
        width,
        height,
        ((UiWidth() / 2) - (width / 2)),
        ((UiHeight() / 2) - (height / 2)),
        true
    )
end
