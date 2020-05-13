-- Resource Metadata
fx_version 'bodacious'
game 'gta5'

author 'GabeSteamcore'
description 'adds various utilities funtions'
version '0.1'

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    "playerHandling.lua",
    "ArgChecking.lua",
    "VariousUtilities.lua",
}

server_exports {
    "GetPlayer",
    "checkPlayerID",
    "checkDuration",
    "checkReason",
    "client_print",
    "client_message",
    "client_notify",
    "GetPlayerRoles",
    "isPlayerRole",
    "isInTable",
}

client_scripts {
    "Messaging.lua",
    "VariousUtilities.lua",
}

exports {
    "isInTable",
}

dependencies {
    'async',
}