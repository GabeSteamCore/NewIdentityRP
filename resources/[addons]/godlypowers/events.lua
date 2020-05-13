------------------------------------------------- KICK -------------------------------------------------
-- /kick <playerID> <reason>
RegisterServerEvent("godlypowers:kickPlayer")
AddEventHandler("godlypowers:kickPlayer", function(target, reason)
    DropPlayer(target, reason)
    client_log(source, "^4[Player Kicked] ^7" .. GetPlayerName(target) .. " was kicked for : " .. reason)
end)

------------------------------------------------- BAN -------------------------------------------------
-- /ban <playerID> <duration in days> <reason>
RegisterServerEvent("godlypowers:banPlayer")
AddEventHandler("godlypowers:banPlayer", function(source, target, duration, reason, date)
    -- Ban request
    MySQL.Async.execute(
        'INSERT INTO banlist (playerName, steamID, reason, duration, date) VALUES (@playerName, @steamID, @reason, @duration, @date)',
        { 
            ['@playerName'] = GetPlayerName(target),
            ['@steamID']    = exports.lib_utils:GetPlayer("steam", target),
            ['@reason']     = reason,
            ['@duration']   = duration,
            ['@date']       = date,
        },
        banEntryConfirmation(source, target, duration, reason)
    )
end)

-- SQL ban adding request callback
function banEntryConfirmation(source, target, duration, reason)
    if duration == 0 then
        DropPlayer(target, "You have been banned permanently. reason : " .. reason) 
        client_log(source, "^4[Player Banned] ^7" .. GetPlayerName(target) .. " was banned permanently for " .. reason)
    else
        DropPlayer(target, "You have been banned during " .. duration .. " days. reason : " .. reason)
        client_log(source, "^4[Player Banned] ^7" .. GetPlayerName(target) .. " was banned during " .. duration .. " days for : " .. reason)
    end
end

-- /ban-offline <playerName> -s <steamID> <duration in days> <reason>
-- RegisterServerEvent("godlypowers:banOfflinePlayer")
-- AddEventHandler("godlypowers:banOfflinePlayer", function(source, target, duration, reason)
--end)

-- /unban <playerName>
RegisterServerEvent("godlypowers:unbanPlayer")
AddEventHandler("godlypowers:unbanPlayer", function(playerName)
    MySQL.Async.execute(
        'DELETE FROM banlist WHERE playerName = @playerName',
        { 
            ['@playerName'] = playerName,
        },
        unbanEntryConfirmation(source, playerName)
    )
end)

-- SQL ban remove request callback
function unbanEntryConfirmation(source, playerName)
    client_log(source, GetPlayerName(source) .. " has unbanned " .. playerName)
end

-- Player Connection handler
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local steamId =  exports.lib_utils:GetPlayer("steam", source)
    deferrals.defer()

    -- defer mandatory wait!
    Wait(0)
    deferrals.update(string.format("Checking banned players"))

    if steamID ~= -1 then
        -- query database
        MySQL.Async.fetchAll(
            'SELECT * FROM banlist',
            {},
            function (data)
                local banned = false
                local reason = ""
                local duration = 0
                local banExpireDate = 0
            
                if data then
                    for i=1, #data, 1 do
                        if (data[i].steamID == steamId) then -- player is in banned list
                            banExpireDate = (data[i].date//1000) + (data[i].duration * 24 * 60 * 60)
                            if ((data[i].duration == 0) or (banExpireDate > os.date())) then -- ban is still active
                                banned = true
                                reason = data[i].reason
                                duration = data[i].duration
                            end
                        end
                    end
            
                    -- defer mandatory wait!
                    Wait(0)
            
                    if banned then -- player is banned
                        if duration == 0 then -- permanently
                            deferrals.done("You are banned permanently. reason : " .. reason) -- refuse connection
                        else -- temporarilly
                            deferrals.done("You are banned until " .. os.date('%Y-%m-%d', banExpireDate) .. ". reason : " .. reason) -- refuse connection
                        end
                    else
                        deferrals.done()
                    end
                else
                    deferrals.done()
                end
            end
        )
    else
        deferrals.done("You must be logged with steam") -- refuse connection
    end
end)

------------------------------------------------- ROLES -------------------------------------------------
-- /role_grant <playerID> <role>
RegisterServerEvent("godlypowers:roleGrant")
AddEventHandler("godlypowers:roleGrant", function(source, targetName, targetSteamID, role)
    MySQL.Async.execute(
        'INSERT INTO roleslist (playerName, steamID, role) VALUES (@playerName, @steamID, @role)',
        { 
            ['@playerName'] = targetName,
            ['@steamID']    = targetSteamID,
            ['@role']     = role,
        },
        roleGrantEntryConfirmation(source, targetName, role)
    )
end)

function roleGrantEntryConfirmation(source, targetName, role)
    client_log(source, "^4[Role granted] ^7" .. targetName .. " has been granted the " .. role .. " role.")
end

-- /role_revoke <playerID> <role>
RegisterServerEvent("godlypowers:roleRevoke")
AddEventHandler("godlypowers:roleRevoke", function(source, targetName, targetSteamID, role)
    MySQL.Async.execute(
        'DELETE FROM roleslist WHERE steamID = @steamID AND role = @role',
        { 
            ['@steamID'] = targetSteamID,
            ['@role'] = role,
        },
        roleRevokeEntryConfirmation(source, targetName, role)
    )
end)

function roleRevokeEntryConfirmation(source, targetName, role)
    client_log(source, "^4[Role revoked] ^7" .. targetName .. " has been revoked the " .. role .. " role.")
end

-- /role_check <playerID>
RegisterServerEvent("godlypowers:roleCheck")
AddEventHandler("godlypowers:roleCheck", function(source, targetSteamID, playerName)
    local steamID = targetSteamID
    local roles = exports.lib_utils:GetPlayerRoles(targetSteamID)

    if #roles > 0 then
        client_log(source, "^4[Role check] ^7" .. playerName .. " has the following roles : " .. table.concat( roles, ", ", 1, #roles ))
    else
        client_log(source, "^4[Role check] ^7" .. playerName .. " doesn't have any role.")
    end  
end)

-- allows to change message outputs
function client_log(target, str)
    --print("client_log(" .. target .. ", " ..  str .. ")")
    exports.lib_utils:client_print(target, str)
end
