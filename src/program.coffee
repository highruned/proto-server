net = require('net')
sys = require('sys')
game = require('proto-game')
network = game.network

packet_num = 0

class program extends game.program
	constructor: (params) ->
		super(params)

		@id = new network.process_id
			label: 0xAAAA
			epoch: (new Date()).getTime()

	run: () ->
		@emit 'initialized'
	
		game.debug.write "Starting game server (port: " + @port + ").", {level: 9}
		
		@server = net.createServer (socket) =>
			client = new game.client(socket)
			
			client.on 'connect', () =>
				console.log "Connection from " + client.socket.remoteAddress
				
				@clients.push(client)
				
				client.id = new network.process_id
					label: 0xBBBB
					epoch: (new Date()).getTime()
				
			client.on 'data', (data) =>
				console.log "Received [raw]: Length: ", data.length, data
				
				depth = 20
				
				while data.length != 0 && (--depth) > 0
					service_id = data[0]
				
					console.log "Trying to find service: " + service_id
					
					service = @get_service_by_id(service_id)
					
				
					if service
						data = service.receive # continue the stream where this service leaves off
							endpoint: client
							data: data.slice(1)
						
						if data.length == 0
							return # avoid segfault?
						else
							console.log data # what's left?
						
					else
						console.log "Unknown: Service ID: ", service_id, " Data: ", data
						sys.exit
				
				if depth == 0
					console.error "Caught a recursive packet (segfault)."
					console.log "Data: ", data
					process.exit 1
	
		@server.listen(@port)
		
		game.debug.write "Started game server.", {level: 9}
	
		@keep_alive()
		
	keep_alive: () ->
		#setTimeout (() => @keep_alive()), 5000 
		
		
	get_client_by_account: (account) ->
		for client, key in @clients
			if client.account.high == account.high && client.account.low == account.low
				return client
				
	server: null
	port: null
	clients: []
	config: {}

exports.program = program
