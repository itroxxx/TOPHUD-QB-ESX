fx_version 'cerulean'
game 'gta5'

author 'itrox'
description 'A HUD script for FiveM supporting both QBCore and ESX frameworks'
version '1.0.0'

client_scripts {
    'config.lua',
    'client/client.lua'
}

server_scripts {
    'config.lua',
    'server/server.lua'
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/style.css',
    'nui/script.js',
    'nui/fonts/Poppins.ttf',
    'nui/fonts/Quicksand.ttf'
}