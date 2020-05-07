-- /help
RegisterCommand('help', function(source, args, rawCommand)
    local grey = {150,150,150}
    local commands = {
        {"/ban <playerID> <duration> <reason>", "adds target player to banned list, duration is ban time in days, 0 for permanant"},
        {"/unban <playerID>", "removes target player to banned list"},
        {"/kick <playerID> <reason>", "kick target player from the server"},
        {"/tp <playerName1> <playerName2>", "teleports player1 to player2"},
        --{"/list_aces", "list all the Access control entries"},
        --{"/list_principals", "list all the users and their Access control group"},
        --{"/test_ace <principal> <object>", "test if principal is allowed to use object"},
    }

    for i=1, 4 do
        print(commands[i][1] .." : " ..commands[i][2])
    end

    LogDebugInfo("help command called by " .. source)
end, false)

-- /me txt
RegisterCommand("me", function(source, args, rawCommand)
    local message = table.concat(args, " ", 1)

    TriggerEvent("chatMessage", "^6[ME] ^7" .. GetPlayerName(source) .. ": " .. message)
end, false)
