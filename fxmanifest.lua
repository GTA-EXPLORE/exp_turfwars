fx_version "adamant"
game "gta5"
lua54 'yes'

author 'EXPLORE, MilyonJames'
description 'https://www.gta-explore.com'

ui_page 'client/ui/index.html'

files {
	'client/ui/**/*'
}

client_scripts {
	"locales/*",
	'config.lua',
	'client/*',
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"locales/*",
	'config.lua',
	'server/*',
}