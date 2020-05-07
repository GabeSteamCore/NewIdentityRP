--------------------------------------------- COMMANDS ---------------------------------------------
-- /kick <playerID> <reason>
RegisterCommand("kick", function(source, args, rawCommand)
    local badBoi = tonumber(args[1])
    local kickReason = table.concat(args, " ", 2)

    if badBoi then
        if kickReason == nil then
            kickReason = "No Reason Provided"
        end
        -- Swapped these two around to stop any potential errors. Chat message should be before the drop.
        print("^4^*[Player Kicked] ^7" .. GetPlayerName(badBoi) .. " was kicked for:" .. kickReason)
        DropPlayer(badBoi, kickReason)
    else
        print("^1Invalid Player. Usage /kick ID Reason") -- In the video it's -1 which is everyone, so lets make it 'source'
    end

end, true)

-- /ban <playerID> <duration in days> <reason>
RegisterCommand("ban", function(source, args, rawCommand)
    local target = tonumber(args[1])
    local duration = tonumber(args[2])
    local reason = table.concat(args, " ", 3)
    local date = os.date("%Y-%m-%d")
    local err = ""
    
    -- Checking arguments
    err = checkArg.playerID(target)
    if err then
        print("/ban failed : " .. err .. ". Usage /ban <playerID> <duration in days> <reason>")
    else 
        err = checkArg.duration(duration)
        if err then
            print("/ban failed : " .. err .. ". Usage /ban <playerID> <duration in days> <reason>")
        else 
            err = checkArg.reason(reason)
            if err then
                print("/ban failed : " .. err .. ". Usage /ban <playerID> <duration in days> <reason>")
            else
                --print("Sending ban entry to database")
                -- Ban request
                MySQL.Async.execute(
                    'INSERT INTO banlist (playerName, steamID, reason, duration, date) VALUES (@playerName, @steamID, @reason, @duration, @date)',
                    { 
                        ['@playerName'] = GetPlayerName(target),
                        ['@steamID']    = GetPlayer("steam", target),
                        ['@reason']     = reason,
                        ['@duration']   = duration,
                        ['@date']       = date,
                    },
                    banEntryConfirmation(source, target, duration, reason)
                )
            end
        end
    end
end)

-- SQL ban adding request callback
function banEntryConfirmation(source, target, duration, reason)
    if duration == 0 then
        print(GetPlayerName(source) .. " banned ", GetPlayerName(target) .. " permanently. reason : " .. reason)
        DropPlayer(target, "You have been banned permanently. reason : " .. reason) 
    else
        print(GetPlayerName(source) .. " banned ", GetPlayerName(target) .. " during " .. duration .. " days. reason : " .. reason)
        DropPlayer(target, "You have been banned during " .. duration .. " days. reason : " .. reason)
    end
end

-- /unban <playerName>
RegisterCommand("unban", function(source, args, rawCommand)
    local playerName = table.concat(args, " ", 1)

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
    print(GetPlayerName(source) .. " has unbanned " .. playerName)
end

RegisterCommand("test", function(source, args, rawCommand)
    local banned = false

    MySQL.Async.fetchAll(
        'SELECT * FROM banlist',
        {},
        function(data)
            local reason = ""
            local duration = 0
            local banExpireDate = 0

            print(os.time(dt))

            for i=1, #data, 1 do
                if (data[i].steamID == GetPlayer("steam", source)) then -- player is in banned list
                    banExpireDate = (data[i].date//1000) + (data[i].duration * 24 * 60 * 60)
                    if ((data[i].duration == 0) or (banExpireDate > os.date())) then -- ban is still active
                        banned = true
                        reason = data[i].reason
                        duration = data[i].duration
                    end
                end
            end

            if banned then
                if duration == 0 then
                    print("You are banned permanently. reason : " .. reason)
                else
                    print()
                end
            end
        end
    )
end)

--------------------------------------- Utilities ---------------------------------------

-- Player Connection handler
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local steamId = GetPlayer("steam", source)
    deferrals.defer()

    -- defer mandatory wait!
    Wait(0)
    deferrals.update(string.format("Checking banned players"))

    -- query database
    MySQL.Async.fetchAll(
        'SELECT * FROM banlist',
        {},
        function(data)
            local banned = false
            local reason = ""
            local duration = 0
            local banExpireDate = 0

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
                    deferrals.done("You are banned until " .. os.date('%Y-%m-%d', banExpireDate) .. ". reason : " .. reason) -- allow connection
                end
            else
                deferrals.done()
            end
        end
    )
end)

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

-- YYYY-MM-DD formatted date to timestamp UNTESTED
function toTimeStamp(dateString)
    local y, m, d = string.match(dateString, "(%d+)-(%d+)-(%d+)")
    local timestamp = os.time{day=d, year=y, month=m}
	return timestamp
end

checkArg = {}

function checkArg.playerID(playerID)
    if (type(playerID) ~= "number")         then error("playerID must be a number") end -- is a number
    if (playerID ~= math.floor(playerID))   then error("playerID must be an integer") end -- is an integer
    if (playerID < 0)                       then error("playerID must be positive") end -- is positive
    if not(GetPlayerName(playerID))         then error("playerID must refer to a connected player") end -- refer to a player
end

function checkArg.duration(duration)
    if (type(duration) ~= "number")         then error("duration must be a number") end -- is a number
    if (duration ~= math.floor(duration))   then error("duration must be an integer") end -- is an integer
    if (duration < 0)                       then error("duration must be positive") end -- is positive
end

function checkArg.reason(reason)
    if (type(reason) ~= "string")           then error("reason must be a string") end -- is a string
    if (string.len(reason) > 255)           then error("reason must be less than 255 caracters") end -- is short enough
    if (string.len(reason) == 0)            then error("reason cannot be blank") end -- is blank
    if (string.len(reason) == "no reason")  then error("don't be a jerk") end -- no reason
end