box.cfg {
	listen = 'localhost:3301'
}

box.once('access:v1', function()
	box.schema.user.grant('guest', 'super')
end)

box.once('database_space', function()
	sp = box.schema.space.create('database')
	sp:create_index('primary', {type = 'tree', parts = { 1, 'string' } })
end)

require('trigger')
require('databaseService')
