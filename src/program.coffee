net = require('net')
game = require('proto-game')

packet_num = 0

class program extends game.program
	constructor: () ->
		super()

	run: () ->
		@emit 'initialized'
	
		game.debug.write "Starting game server (port: 1119)...", {level: 9}
		
		@server = net.createServer (client) =>
			client.on 'connect', () =>
				console.log('Connection from ' + client.remoteAddress)
				
				@clients.push(client)
				
			client.on 'data', (message) =>
				service_id = message[0]
				
				@services[@get_service_by_id(service_id).name].process_message(client, message.slice(1))
	
		@server.listen(1119)
		
		game.debug.write "Started game server.", {level: 9}
	
		@keep_alive()
		
	keep_alive: () ->
		setTimeout (() => @keep_alive()), 5000 
		
	server: null
	port: null
	clients: []
	config: {}

exports.program = program
