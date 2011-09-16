net = require('net')
game = require('proto-game')
network = game.network

packet_num = 0

class program extends game.program
	constructor: () ->
		super()

		@id = new network.process_id
			label: Math.floor(Math.random() * 99999)
			epoch: (new Date()).getTime()

	run: () ->
		@emit 'initialized'
	
		game.debug.write "Starting game server (port: 1119)...", {level: 9}
		
		@server = net.createServer (client) =>
			client.on 'connect', () =>
				console.log('Connection from ' + client.remoteAddress)
				
				@clients.push(client)
				
				client.id = new network.process_id
					label: Math.floor(Math.random() * 99999)
					epoch: (new Date()).getTime()
				
			client.on 'data', (message) =>
				service_id = message[0]
				
				console.log "Received [raw]: Length: ", message.length, message
				
				console.log "Trying to find service (" + service_id + ")."
				
				if service_id == 0xfe
					service_id = 0
				
				@services[@get_service_by_id(service_id).name].receive
					endpoint: client
					message: message.slice(1)
	
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
