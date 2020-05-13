RegisterNetEvent("lib_utils:clientprint")
AddEventHandler("lib_utils:clientprint", function(str)
    print(str)
end)

RegisterNetEvent("lib_utils:clientmessage")
AddEventHandler("lib_utils:clientmessage", function(_color, _multiline, _args)
    TriggerEvent(
        'chat:addMessage',
        {
            color = _color,
            multiline = _multiline,
            args = _args
        }
    )
end)

RegisterNetEvent("lib_utils:clientnotify")
AddEventHandler("lib_utils:clientnotify", function(str)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(str)
    DrawNotification(true, false) -- More options can be found here https://runtime.fivem.net/doc/natives/#_0x2ED7843F8F801023
end)