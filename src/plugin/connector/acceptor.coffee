game = require('proto-game')
plugin = game.plugin
network = game.network

class acceptor extends plugin
	constructor: (@program) ->
		if @program
			@set_program(@program)
	
	set_program: (@program) ->
		@program.on 'initialized', () =>
			@connection_service = @program.get_service('connection')
		
			@connection_service.on 'connect_request', (client, length) =>
				client_id = new network.process_id()
				client_id.label = 10000
				client_id.epoch = (new Date()).getTime()
			
				server_id = new network.process_id()
				server_id.label = 10000
				server_id.epoch = (new Date()).getTime()
			
				r1 = new network.connection.connect_response()
				r1.client_id = client_id
				r1.server_id = server_id
				
				@connection_service.send 0x03, client, r1
			
			@connection_service.on 'bind_request', (client, length) =>
				r1 = new network.connection.bind_response()
			
				r1.imported_service_hash = 'hash here'
				
				exported_service = new network.connection.bound_service()
				r1.exported_service = exported_service
				
				@connection_service.send 0x04, client, r1
					
	
	connection_service: null
	program: null
	
exports.acceptor = acceptor