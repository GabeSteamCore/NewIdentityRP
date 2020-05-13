function checkPlayerID(playerID)
    if (type(playerID) ~= "number")         then return "playerID must be a number" end -- is a number
    if (playerID ~= math.floor(playerID))   then return "playerID must be an integer" end -- is an integer
    if (playerID < 0)                       then return "playerID must be positive" end -- is positive
    if (GetPlayerPing(playerID) <= 0)       then return "playerID must refer to a connected player" end -- refer to a player
    return ""
end

function checkDuration(duration)
    if (type(duration) ~= "number")         then return "duration must be a number" end -- is a number
    if (duration ~= math.floor(duration))   then return "duration must be an integer" end -- is an integer
    if (duration < 0)                       then return "duration must be positive" end -- is positive
    return ""
end

function checkReason(reason)
    if (type(reason) ~= "string")           then return "reason must be a string" end -- is a string
    if (string.len(reason) > 255)           then return "reason must be less than 255 caracters" end -- is short enough
    if (string.len(reason) == 0)            then return "reason cannot be blank" end -- is blank
    if (string.len(reason) == "no reason")  then return "don't be a jerk" end -- no reason
    return ""
end