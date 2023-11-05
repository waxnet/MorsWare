menu = {}
do
	menu.data = {
		["draw"] = false,
		["tab"] = "combat",
		["tab_offset"] = 0,
		["section_offset"] = 0
	}
	
	menu.reset = function()
		menu.data["tab_offset"] = 0
		menu.data["section_offset"] = 0
	end

	menu.new_tab = function(data)
		local name = data["name"]
		local components = data["components"]
		
		local tab_id = string.lower(name)
		
		UiPush()
			UiTranslate(menu.data["tab_offset"])
			UiFont("bold.ttf", 14)
			UiAlign("middle")
			
			if menu.data["tab"] ~= tab_id then
				UiColor(.6, .6, .6)
			end
			
			if UiTextButton(name) then
				menu.data["tab"] = tab_id
			end
			
			local tab_w, tab_h = UiGetTextSize(name)
			menu.data["tab_offset"] = menu.data["tab_offset"] + tab_w
		UiPop()
		
		if menu.data["tab"] == tab_id then
			UiPush()
				UiTranslate(-5, 10)
				
				components()
			UiPop()
		end
	end
	
	menu.new_section = function(data)
		local name = data["name"]
		local components = data["components"]
	
		UiTranslate(menu.data["section_offset"], 0)
		UiPush()
			UiFont("bold.ttf", 24)
			UiAlign("top left")
			
			UiText(name, true)
			
			components()
		UiPop()

		if menu.data["section_offset"] == 0 then
			menu.data["section_offset"] = 170
		end
	end
	
	menu.new_subsection = function(name)
		UiFont("bold.ttf", 20)
		UiAlign("top left")
		
		UiText(name, true)
	end
	
	menu.new_toggle = function(data)
		local text = " - " .. data["text"] .. " = "
        local path = "savegame.mod." .. data["path"]
        
        if not HasKey(path) then
            SetBool(path, false)
        end

        UiPush()
            UiFont("bold.ttf", 16)

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

					config.refresh()
                end
            UiPop()
        UiPop()
        UiTranslate(0, text_height)
	end
	
	menu.new_slider = function(data)
		local text = " - " .. data["text"] .. " = "
        local path = "savegame.mod." .. data["path"]
        local max = data["max"]
        local min = data["min"]

        if not HasKey(path) then
            SetInt(path, max)
        end

        UiPush()
            UiFont("bold.ttf", 16)

            local text_width, text_height = UiGetTextSize(text)
            local slider_value = GetInt(path)
            local path_value_width, path_value_height = UiGetTextSize(tostring(slider_value))

            UiPush()
                UiFont("bold.ttf", 20)
                local plus_width, plus_height = UiGetTextSize("+")
                local minus_width, minus_height = UiGetTextSize("-")
            UiPop()

            UiText(text)
            UiPush()
                UiTranslate(text_width - 2, 0)
                UiText(tostring(slider_value))

                UiTranslate(path_value_width - 2, 1)
                UiPush()
                    UiFont("bold.ttf", 20)
                    UiText("+")
                UiPop()
                if UiIsMouseInRect(plus_width, plus_height) and InputDown("lmb") and slider_value < max then
                    SetInt(path, slider_value + 1)

					config.refresh()
                end

                UiTranslate(13, 2)
                UiPush()
                    UiFont("bold.ttf", 20)
                    UiText("-")
                UiPop()
                if UiIsMouseInRect(minus_width, minus_height) and InputDown("lmb") and slider_value > min then
                    SetInt(path, slider_value - 1)

					config.refresh()
                end
            UiPop()
        UiPop()
        UiTranslate(0, text_height)
	end
	
	menu.new_list = function(data)
        local text = " - " .. data["text"] .. " = "
        local path = "savegame.mod." .. data["path"]
        local options = data["options"]
        
        if not HasKey(path) then
            SetString(path, options[1])
        end

        UiPush()
            UiFont("bold.ttf", 16)

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

					config.refresh()
                end
            UiPop()
        UiPop()
        UiTranslate(0, text_height)
    end

	menu.draw_menu = function(width, height, x, y, force)
		local force = force or false

		if InputPressed("alt") then
			menu.data["draw"] = not menu.data["draw"]
		end
		if not menu.data["draw"] and not force then
			return
		end

		-- window
		UiMakeInteractive()
		UiBlur(.25)
		UiTranslate(x, y)
		UiColor(.3, .3, .3)
		UiRect((width + 2), (height + 2))
		
		UiTranslate(1, 1)
		UiColor(.1, .1, .1)
		UiRect(width, height)
		
		-- rgb line
		local title_rgb = {1, 1, 1}
		local version_rgb = {1, 1, 1}

		UiPush()
			local rgb_range = ((width / 2) - 1)
			for offset = 0, rgb_range do
				local r, g, b = utilities.rgb((offset / rgb_range) * 4)
				UiColor(r, g, b)
				
				UiRect(2, 2)
				UiTranslate(2, 0)

				if offset == 20 then
					title_rgb = {r, g, b}
				elseif offset == (rgb_range - 20) then
					version_rgb = {r, g, b}
				end
			end
		UiPop()
		
		-- components
		UiPush()
			UiFont("bold.ttf", 14)
			UiButtonPressDist(0)
			UiColor(1, 1, 1)

			-- title and version line
			UiPush()
				UiTranslate(4, 18)
				UiColor(.3, .3, .3)
				UiRect(width - 8, 1)
			UiPop()
			UiPush()
				UiColor(title_rgb[1], title_rgb[2], title_rgb[3])
				UiTranslate(6, 9)
				UiAlign("middle")
				UiText("MorsWare")
			UiPop()
			UiPush()
				UiColor(version_rgb[1], version_rgb[2], version_rgb[3])
				UiTranslate((width - 3), 9)
				UiAlign("middle right")
				UiText("v1.2")
			UiPop()
			UiTranslate(0, 18)

			-- tabs line
			UiPush()
				UiTranslate(4, 18)
				UiColor(.3, .3, .3)
				UiRect(width - 8, 1)
			UiPop()
			UiTranslate(6, 9)
			
			-- combat
			menu.new_tab({
				["name"] = "Combat",
				["components"] = function()
					-- aimbot
					menu.new_section({
						["name"] = "Aimbot",
						["components"] = function()
							menu.new_toggle({
								["text"] = "Enabled",
								["path"] = "aimbot.enabled"
							})
							
							-- fov
							menu.new_subsection("FOV")
							menu.new_toggle({
								["text"] = "Check",
								["path"] = "aimbot.config.fov.check"
							})
							menu.new_slider({
								["text"] = "Size",
								["path"] = "aimbot.config.fov.size",
								["max"] = 400,
								["min"] = 10
							})
							menu.new_toggle({
								["text"] = "Draw",
								["path"] = "aimbot.config.fov.draw"
							})
							menu.new_slider({
								["text"] = "Sides",
								["path"] = "aimbot.config.fov.sides",
								["max"] = 80,
								["min"] = 12
							})
							menu.new_list({
								["text"] = "Rainbow",
								["path"] = "aimbot.config.fov.rainbow",
								["options"] = {
									"disabled",
									"normal",
									"wave"
								}
							})

							-- smoothing
							menu.new_subsection("Smoothing")
							menu.new_toggle({
								["text"] = "Enabled",
								["path"] = "aimbot.config.smoothing.enabled"
							})
							menu.new_slider({
								["text"] = "Amount",
								["path"] = "aimbot.config.smoothing.amount",
								["max"] = 80,
								["min"] = 0
							})

							-- visibility
							menu.new_subsection("Visibility")
							menu.new_toggle({
								["text"] = "Check",
								["path"] = "aimbot.config.visibility.check"
							})

							-- distance
							menu.new_subsection("Distance")
							menu.new_toggle({
								["text"] = "Check",
								["path"] = "aimbot.config.distance.check"
							})
							menu.new_slider({
								["text"] = "Range",
								["path"] = "aimbot.config.distance.range",
								["max"] = 1000,
								["min"] = 0
							})

							-- other
							menu.new_subsection("Other")
							menu.new_list({
								["text"] = "Target",
								["path"] = "aimbot.config.target",
								["options"] = {
									"head",
									"torso"
								}
							})
						end
					})

					-- silent aim
					menu.new_section({
						["name"] = "Silent Aim",
						["components"] = function()
							menu.new_toggle({
								["text"] = "Enabled",
								["path"] = "silentaim.enabled"
							})
							
							-- fov
							menu.new_subsection("FOV")
							menu.new_toggle({
								["text"] = "Check",
								["path"] = "silentaim.config.fov.check"
							})
							menu.new_slider({
								["text"] = "Size",
								["path"] = "silentaim.config.fov.size",
								["max"] = 400,
								["min"] = 10
							})
							menu.new_toggle({
								["text"] = "Draw",
								["path"] = "silentaim.config.fov.draw"
							})
							menu.new_slider({
								["text"] = "Sides",
								["path"] = "silentaim.config.fov.sides",
								["max"] = 80,
								["min"] = 12
							})
							menu.new_list({
								["text"] = "Rainbow",
								["path"] = "silentaim.config.fov.rainbow",
								["options"] = {
									"disabled",
									"normal",
									"wave"
								}
							})

							-- visibility
							menu.new_subsection("Visibility")
							menu.new_toggle({
								["text"] = "Check",
								["path"] = "silentaim.config.visibility.check"
							})

							-- distance
							menu.new_subsection("Distance")
							menu.new_toggle({
								["text"] = "Check",
								["path"] = "silentaim.config.distance.check"
							})
							menu.new_slider({
								["text"] = "Range",
								["path"] = "silentaim.config.distance.range",
								["max"] = 1000,
								["min"] = 0
							})
						end
					})
				end
			})

			-- movement
			menu.new_tab({
				["name"] = "Movement",
				["components"] = function()
					-- nofall
					menu.new_section({
						["name"] = "No Fall",
						["components"] = function()
							menu.new_toggle({
								["text"] = "Enabled",
								["path"] = "movement.no_fall"
							})
							menu.new_list({
								["text"] = "Mode",
								["path"] = "movement.no_fall_mode",
								["options"] = {
									"glide",
									"reset",
									"teleport",
								}
							})
						end
					})
				end
			})
			
			-- visual
			menu.new_tab({
				["name"] = "Visual",
				["components"] = function()
					-- esp
					menu.new_section({
						["name"] = "ESP",
						["components"] = function()
							menu.new_toggle({
								["text"] = "Enabled",
								["path"] = "esp.enabled"
							})

							-- targets
							menu.new_subsection("Targets")
							menu.new_toggle({
								["text"] = "Entities",
								["path"] = "esp.targets.entities"
							})
							menu.new_toggle({
								["text"] = "Loot",
								["path"] = "esp.targets.loot"
							})

							-- modes
							menu.new_subsection("Modes")
							menu.new_toggle({
								["text"] = "Nametags",
								["path"] = "esp.config.nametags"
							})
							menu.new_toggle({
								["text"] = "Bones",
								["path"] = "esp.config.bones"
							})
							menu.new_toggle({
								["text"] = "Outlines",
								["path"] = "esp.config.outlines"
							})
							menu.new_toggle({
								["text"] = "Highlights",
								["path"] = "esp.config.highlights"
							})
							menu.new_toggle({
								["text"] = "Tracers",
								["path"] = "esp.config.tracers"
							})
							menu.new_toggle({
								["text"] = "Boxes",
								["path"] = "esp.config.boxes"
							})
							menu.new_toggle({
								["text"] = "Radar",
								["path"] = "esp.config.radar"
							})
						end
					})
				end
			})

			-- exploits
			menu.new_tab({
				["name"] = "Exploits",
				["components"] = function()
					-- force nv
					menu.new_section({
						["name"] = "Force NV",
						["components"] = function()
							menu.new_toggle({
								["text"] = "Enabled",
								["path"] = "exploits.force_nv"
							})
							menu.new_list({
								["text"] = "Mode",
								["path"] = "exploits.force_nv_mode",
								["options"] = {
									"thermals",
									"pnv10t",
									"nvg",
									"pvs14"
								}
							})
						end
					})

					-- infinite fuel
					menu.new_section({
						["name"] = "Infinite Fuel",
						["components"] = function()
							menu.new_toggle({
								["text"] = "Enabled",
								["path"] = "exploits.infinite_fuel"
							})
						end
					})

					-- instant revive
					menu.new_section({
						["name"] = "Instant Revive",
						["components"] = function()
							menu.new_toggle({
								["text"] = "Enabled",
								["path"] = "exploits.instant_revive"
							})
						end
					})
				end
			})
			
			menu.reset()
		UiPop()
	end
end
