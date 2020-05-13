-- /help
RegisterCommand('help', function(source, args, rawCommand)
    -- permission checking
    if exports.lib_utils:isPlayerRole(source, {"admin"}) then
        local grey = {150,150,150}
        local commands = {
            {"/ban <playerID> <duration> <reason>", "adds target player to banned list, duration is ban time in days, 0 for permanant"},
            --{"/banoffline <playerID> <steamID> <duration> <reason>", "adds target player to banned list, duration is ban time in days, 0 for permanant"},
            {"/unban <playerName>", "removes target player from banned list"},
            {"/kick <playerID> <reason>", "kick target player from the server"},
            {"/role_grant <playerID> <role>", "adds a role to target player"},
            {"/role_revoke <playerID> <role>", "removes a role to target player"},
            {"/role_check <playerID>", "list player's roles"},
            --{"/tp <playerName1> <playerName2>", "teleports player1 to player2"},
            --{"/list_aces", "list all the Access control entries"},
            --{"/list_principals", "list all the users and their Access control group"},
            --{"/test_ace <principal> <object>", "test if principal is allowed to use object"},
        }

        -- printing commands
        for i=1, #commands do
            client_log(source, commands[i][1] .." : " ..commands[i][2])
        end
    else
        client_log(source, "You don't have the permission to use this command")
    end
end)

------------------------------------------------- KICK -------------------------------------------------
-- /kick <playerID> <reason>
RegisterCommand("kick", function(source, args, rawCommand)
    -- permission checking
    if exports.lib_utils:isPlayerRole(source, {"admin"}) then
        local target = tonumber(args[1])
        local reason = table.concat(args, " ", 2)

        -- arguments checking
        err = exports.lib_utils:checkPlayerID(target)
        if (err ~= "") then
            client_log(source, "/kick failed : " .. err .. ". Usage /kick <playerID> <reason>.")
        else
            err = exports.lib_utils:checkReason(reason)
            if (err ~= "") then
                client_log(source, "/kick failed : " .. err .. ". Usage /kick <playerID> <reason>.")
            else
                -- sending command
                TriggerEvent("godlypowers:kickPlayer", target, reason)
            end
        end
    else
        client_log(source, "You don't have the permission to use this command")
    end
end)

------------------------------------------------- BAN -------------------------------------------------
-- /ban <playerID> <duration in days> <reason>
RegisterCommand("ban", function(source, args, rawCommand)
    -- permission checking
    if exports.lib_utils:isPlayerRole(source, {"admin"}) then
        local target = tonumber(args[1])
        local duration = tonumber(args[2])
        local reason = table.concat(args, " ", 3)
        local date = os.date("%Y-%m-%d")
        local err = ""
        
        -- arguments checking
        err = exports.lib_utils:checkPlayerID(target)
        if (err ~= "") then
            client_log(source, "/ban failed : " .. err .. ". Usage /ban <playerID> <duration in days> <reason>")
        else 
            err = exports.lib_utils:checkDuration(duration)
            if (err ~= "") then
                client_log(source, "/ban failed : " .. err .. ". Usage /ban <playerID> <duration in days> <reason>")
            else 
                err = exports.lib_utils:checkReason(reason)
                if (err ~= "") then
                    client_log(source, "/ban failed : " .. err .. ". Usage /ban <playerID> <duration in days> <reason>")
                else
                    -- sending command
                    TriggerEvent("godlypowers:banPlayer", source, target, duration, reason, date)
                end
            end
        end
    else
        client_log(source, "You don't have the permission to use this command")
    end
end)

-- /ban-offline <playerName> -s <steamID> <duration in days> <reason>
--RegisterCommand("ban", function(source, args, rawCommand)
--end)

-- /unban <playerName>
RegisterCommand("unban", function(source, args, rawCommand)
    -- permission checking
    if exports.lib_utils:isPlayerRole(source, {"admin"}) then
        local playerName = table.concat(args, " ", 1)

        -- sending command
        TriggerEvent("godlypowers:unbanPlayer", playerName)
    else
        client_log(source, "You don't have the permission to use this command")
    end
end)

------------------------------------------------- ROLES -------------------------------------------------
-- /role_grant <playerID> <role>
RegisterCommand("role_grant", function(source, args, rawCommand)
    -- permission checking
    if exports.lib_utils:isPlayerRole(source, {"admin"}) then
        local targetID = tonumber(args[1])
        local role = tostring(args[2])

        local targetSteamID = ""
        local targetName = ""
        local err = ""

        -- arguments checking
        err = exports.lib_utils:checkPlayerID(targetID)
        if (err ~= "") then
            client_log(source, "/role_grant failed : " .. err .. ". Usage /role_grant <playerID> <role>.")
        else
            -- formating arguments
            targetSteamID = exports.lib_utils:GetPlayer("steam", targetID)
            targetName = GetPlayerName(targetID)

            -- sending command
            TriggerEvent("godlypowers:roleGrant", source, targetName, targetSteamID, role)
        end
    else
        client_log(source, "You don't have the permission to use this command")
    end
end)

-- /role_revoke <playerID> <role>
RegisterCommand("role_revoke", function(source, args, rawCommand)
    -- permission checking
    if exports.lib_utils:isPlayerRole(source, {"admin"}) then
        local targetID = tonumber(args[1])
        local role = tostring(args[2])

        local targetSteamID = ""
        local targetName = ""
        local err = ""

        -- arguments checking
        err = exports.lib_utils:checkPlayerID(targetID)
        if (err ~= "") then
            client_log(source, "/role_revoke failed : " .. err .. ". Usage /role_revoke <playerID> <role>.")
        else
            --formatinf arguments
            targetSteamID = exports.lib_utils:GetPlayer("steam", targetID)
            targetName = GetPlayerName(targetID)

            -- sending command
            TriggerEvent("godlypowers:roleRevoke", source, targetName, targetSteamID, role)
        end
    else
        client_log(source, "You don't have the permission to use this command")
    end
end)

-- /role_check <playerID>
RegisterCommand("role_check", function(source, args, rawCommand)
    -- permission checking
    if exports.lib_utils:isPlayerRole(source, {"admin"}) then
        local targetID = tonumber(args[1])
        local playerName = ""
        local targetSteamID = ""

        -- arguments checking
        err = exports.lib_utils:checkPlayerID(targetID)
        if (err ~= "") then
            client_log(source, "/role_check failed : " .. err .. ". Usage /role_check <playerID>.")
        else
            -- formating arguments
            targetSteamID = exports.lib_utils:GetPlayer("steam", targetID)
            playerName = GetPlayerName(targetID)

            --sending command
            TriggerEvent("godlypowers:roleCheck", source, targetSteamID, playerName)
        end
    else
        client_log(source, "You don't have the permission to use this command")
    end
end)
