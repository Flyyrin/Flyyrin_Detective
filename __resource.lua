fx_version 'adamant'
games { 'rdr3', 'gta5' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'


author 'Flyyrin'
description 'Police Detective Menu'
version '1.0.0'

server_scripts {
	'server/*.lua',
}

client_script 'NativeUI.lua'
client_scripts {
	'client/*.lua',
}

shared_scripts {
	'config.lua',
}
