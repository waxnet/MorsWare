registry = {}
do
    registry.get_bool = function(path)
        local complete_path = "savegame.mod." .. path

        if not HasKey(complete_path) then
            SetBool(complete_path, false)
            return false
        end

        return GetBool(complete_path)
    end

    registry.get_int = function(path, default)
        local complete_path = "savegame.mod." .. path

        if not HasKey(complete_path) then
            SetInt(complete_path, default)
            return default
        end

        return GetInt(complete_path)
    end

    registry.get_string = function(path, default)
        local complete_path = "savegame.mod." .. path

        if not HasKey(complete_path) then
            SetString(complete_path, default)
            return default
        end

        return GetString(complete_path)
    end
end