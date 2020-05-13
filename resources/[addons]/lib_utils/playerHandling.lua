-- extract a data field from a player's "source"
-- field {string} = "license", "steam", fivem, "discord", "ip" 
function GetPlayer(field, source)
    local fieldValue = -1

    for k,v in ipairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len(field..":")) == field ..":" then
            fieldValue = v
        end
    end

    return fieldValue
end

-- prints str into target player's in game console 
function client_print(target, str)
    --print("client_print(" .. target .. ", " .. str .. ")")
    TriggerClientEvent("lib_utils:clientprint", target, str)
end

-- prints chat message into taget player's chat (uses TriggerEvent("addmessage") arguments)
function client_message(target, color, multiline, arg)
    --print("client_message(" .. target .. ", " .. table.concat(color, ", ", 1, #color) .. ", " .. tostring(multiline) .. ", " .. table.concat(arg, ": ", 1, #arg) ..")")
    TriggerClientEvent("lib_utils:clientmessage", target, color, multiline, arg)
end

-- pop up a notification on target player's screen
function client_notify(target, str)
    --print("client_notify(" .. target .. ", " .. str .. ")")
    TriggerClientEvent("lib_utils:clientnotify", target, str)
end

function GetPlayerRoles(targetSteamID)
    local roles = {}
    local data = MySQL.Sync.fetchAll('SELECT * FROM roleslist',{})

    if #data > 0 then
        for i=1, #data, 1 do
            --print("data[" .. i .. "] = {" .. data[i].playerName .. ", " .. data[i].steamID .. ", " .. data[i].role .. "}")
            if data[i].steamID == targetSteamID then
                table.insert(roles, data[i].role)
            end
        end
    end

    return roles
end

function isPlayerRole(source, roles)
    return isInTable(GetPlayerRoles(exports.lib_utils:GetPlayer("steam", source)), roles)
end