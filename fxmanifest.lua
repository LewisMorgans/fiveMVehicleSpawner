fx_version "cerulean"

description "Basic vehicle spawner script based dictionary passed to react FE"
author "Lewis Morgans"
version '1.0.0-beta'
repository 'https://github.com/LewisMorgans/fiveMVehicleSpawner'

lua54 'yes'

games {
  "gta5",
  "rdr3"
}

ui_page 'web/build/index.html'

client_script "client/**/*"
server_script "server/**/*"

files {
	'web/build/index.html',
	'web/build/**/*',
}