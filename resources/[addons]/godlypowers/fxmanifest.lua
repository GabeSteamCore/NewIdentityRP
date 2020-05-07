-- Resource Metadata
fx_version 'bodacious'
game 'gta5'

author 'GabeSteamcore'
description 'Adds admin commands'
version '0.1'

-- What to run
client_scripts {
    'client.lua'
}

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    'server.lua',
}

dependencies {
	'async'
}
