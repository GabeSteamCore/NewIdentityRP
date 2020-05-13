-- Resource Metadata
fx_version 'bodacious'
game 'gta5'

author 'GabeSteamcore'
description 'Adds admin commands'
version '0.1'

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    'events.lua',
    'commands.lua',
}

client_scripts {
    'client.lua'
}

dependencies {
    'async',
    'lib_utils',
}
