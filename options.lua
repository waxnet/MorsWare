-- utilities
local utilities = {}
do
    utilities.get_rgb = function()
        local current_time = GetTime()
		return math.sin(current_time) * 0.5 + 0.5, math.sin(current_time + 2) * 0.5 + 0.5, math.sin(current_time + 4) * 0.5 + 0.5
    end

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

-- ui
local ui = {}
do
    ui.new_toggle = function(data)
        local text = " - " .. data["text"] .. " = "
        local path = "savegame.mod." .. data["path"]
        
        if not HasKey(path) then
            SetBool(path, false)
        end

        UiPush()
            UiFont("bold.ttf", 20)

            local text_width, text_height = UiGetTextSize(text)
            local toggle_value = GetBool(path)

            UiText(text)
            UiPush()
                UiTranslate(text_width - 2, 0)

                if toggle_value then
                    UiColor(0, 1, 0)
                else
                    UiColor(1, 0, 0)
                end

                if UiTextButton(tostring(toggle_value)) then
                    SetBool(path, not toggle_value)
                end
            UiPop()
        UiPop()
        UiTranslate(0, text_height)
    end

    ui.new_slider = function(data)
        local text = " - " .. data["text"] .. " = "
        local path = "savegame.mod." .. data["path"]
        local max = data["max"]
        local min = data["min"]

        if not HasKey(path) then
            SetInt(path, max)
        end

        UiPush()
            UiFont("bold.ttf", 20)

            local text_width, text_height = UiGetTextSize(text)
            local slider_value = GetInt(path)
            local path_value_width, path_value_height = UiGetTextSize(tostring(slider_value))

            UiPush()
                UiFont("bold.ttf", 25)
                local plus_width, plus_height = UiGetTextSize("+")
                local minus_width, minus_height = UiGetTextSize("-")
            UiPop()

            UiText(text)
            UiPush()
                UiTranslate(text_width - 2, 0)
                UiText(tostring(slider_value))

                UiTranslate(path_value_width - 2, 1)
                UiPush()
                    UiFont("bold.ttf", 25)
                    UiText("+")
                UiPop()
                if UiIsMouseInRect(plus_width, plus_height) and InputDown("lmb") and slider_value < max then
                    SetInt(path, slider_value + 1)
                end

                UiTranslate(15, 4)
                UiPush()
                    UiFont("bold.ttf", 25)
                    UiText("-")
                UiPop()
                if UiIsMouseInRect(minus_width, minus_height) and InputDown("lmb") and slider_value > min then
                    SetInt(path, slider_value - 1)
                end
            UiPop()
        UiPop()
        UiTranslate(0, text_height)
    end

    ui.new_list = function(data)
        local text = " - " .. data["text"] .. " = "
        local path = "savegame.mod." .. data["path"]
        local options = data["options"]
        
        if not HasKey(path) then
            SetString(path, options[1])
        end

        UiPush()
            UiFont("bold.ttf", 20)

            local text_width, text_height = UiGetTextSize(text)
            local list_value = GetString(path)
            local list_value_index = utilities.item_index(options, list_value)

            UiText(text)
            UiPush()
                UiTranslate(text_width - 2, 0)

                if UiTextButton(list_value) then
                    local new_list_value = nil
                    if #options == list_value_index then
                        new_list_value = options[1]
                    else
                        new_list_value = options[list_value_index + 1]
                    end
                    
                    SetString(path, new_list_value)
                end
            UiPop()
        UiPop()
        UiTranslate(0, text_height)
    end
end

-- options
function draw()
    -- rainbow colors
    local r, g, b = utilities.get_rgb()

    -- setup
    UiButtonPressDist(0)
    UiAlign("top left")
    UiTranslate(0, 2)

    -- aimbot
    UiPush()
        -- aimbot title
        do
            UiFont("bold.ttf", 50)
            UiColor(r, g, b)

            UiText("Aimbot", true)
        end

        -- aimbot options
        do
            UiColor(1, 1, 1)
            
            -- enabled
            ui.new_toggle({
                ["text"] = "Enabled",
                ["path"] = "aimbot.enabled"
            })

            -- fov
            UiTranslate(0, 10)
            UiFont("bold.ttf", 30)
            UiText("FOV", true)

            ui.new_toggle({
                ["text"] = "Check",
                ["path"] = "aimbot.config.fov.check"
            })

            ui.new_toggle({
                ["text"] = "Draw",
                ["path"] = "aimbot.config.fov.draw"
            })

            ui.new_slider({
                ["text"] = "Size",
                ["path"] = "aimbot.config.fov.size",
                ["max"] = 500,
                ["min"] = 0
            })

            -- visibility
            UiTranslate(0, 10)
            UiFont("bold.ttf", 30)
            UiText("Visibility", true)

            ui.new_toggle({
                ["text"] = "Check",
                ["path"] = "aimbot.config.visibility.check"
            })

            -- distance
            UiTranslate(0, 10)
            UiFont("bold.ttf", 30)
            UiText("Distance", true)

            ui.new_toggle({
                ["text"] = "Check",
                ["path"] = "aimbot.config.distance.check"
            })

            ui.new_slider({
                ["text"] = "Range",
                ["path"] = "aimbot.config.distance.range",
                ["max"] = 1000,
                ["min"] = 0
            })

            -- other
            UiTranslate(0, 10)
            UiFont("bold.ttf", 30)
            UiText("Other", true)

            ui.new_list({
                ["text"] = "Target",
                ["path"] = "aimbot.config.target",
                ["options"] = {
                    "head",
                    "torso"
                }
            })
        end
    UiPop()

    -- esp
    do
        -- offset
        UiTranslate(300, 0)

        UiPush()
            -- esp title
            do
                UiFont("bold.ttf", 50)
                UiColor(r, g, b)

                UiText("ESP", true)
            end

            -- esp options
            do
                UiColor(1, 1, 1)
                
                -- enabled
                ui.new_toggle({
                    ["text"] = "Enabled",
                    ["path"] = "esp.enabled"
                })

                -- targets
                UiTranslate(0, 10)
                UiFont("bold.ttf", 30)
                UiText("Targets", true)

                ui.new_toggle({
                    ["text"] = "Entities",
                    ["path"] = "esp.targets.entities"
                })

                ui.new_toggle({
                    ["text"] = "Loot",
                    ["path"] = "esp.targets.loot"
                })

                -- modes
                UiTranslate(0, 10)
                UiFont("bold.ttf", 30)
                UiText("Modes", true)

                ui.new_toggle({
                    ["text"] = "Nametags",
                    ["path"] = "esp.config.nametags"
                })
                
                ui.new_toggle({
                    ["text"] = "Bones",
                    ["path"] = "esp.config.bones"
                })

                ui.new_toggle({
                    ["text"] = "Outlines",
                    ["path"] = "esp.config.outlines"
                })

                ui.new_toggle({
                    ["text"] = "Highlights",
                    ["path"] = "esp.config.highlights"
                })

                ui.new_toggle({
                    ["text"] = "Tracers",
                    ["path"] = "esp.config.tracers"
                })
            end
        UiPop()
    end
end
