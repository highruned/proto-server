game = require('proto-game')
plugin = game.plugin
network = game.network

class acceptor extends plugin
	constructor: (@program) ->
		if @program
			@set_program(@program)
	
	set_program: (@program) ->
		@program.on 'initialized', () =>
			@default_service = @program.get_service('default')
		
			@default_service.on 'connect_request', (params) =>
				connect_response = new network.connect_response
					client_id: params.endpoint.id
					server_id: @program.id
				
				# hardcoding
				message = new Buffer("fe0000001a0a0c08dde98ebb0e10d4b9acf304120a089f8e0510a1b5b5f304").fromHex()
				console.log 'Sending [fake]: Length: ', message.length, message
				params.endpoint.write(message)
				
				###
				@default_service.send 
					service_id: 0xfe
					method_id: 0
					request_id: params.request_id
					endpoint: params.endpoint
					message: connect_response
				###
			
			@default_service.on 'bind_request', (params) =>
				bind_response = new network.bind_response
					imported_service_id: [
						@program.get_service('connection').id,
						@program.get_service('authentication').id
					]
				
				if params.request_id == 1 # 1st bind request
					# hardcoding
					message = new Buffer("fe000100040a020403").fromHex()
					console.log 'Sending [fake]: Length: ', message.length, message
					params.endpoint.write(message)
				else # 2nd bind request
					# hardcoding
					message = new Buffer("fe000200030a0101").fromHex()
					console.log 'Sending [fake]: Length: ', message.length, message
					params.endpoint.write(message)
				
				###
				@default_service.send 
					service_id: 0xfe
					method_id: 0
					request_id: params.request_id
					endpoint: params.endpoint
					message: bind_response
				###
			
			@authentication_service = @program.get_service('authentication')
			
			@authentication_service.on 'logon_request', (params) =>
				console.log params.message
			
				logon_response = new network.authentication.logon_response
					account: new network.entity_id
						low: 1
						high: 999999999999999
					game_account: new network.entity_id
						low: 1
						high: 999999999999999
				
				
				# hardcoding
				message = new Buffer("2701000025f2020a2c0d5355000015687475611a208f52906a2c85b416a595702251570f96d3522f39237603115f2f1ab24962043c12c1020073cbb9af48b12211166c7c6efb2c73bf7bebfd94fb70ececb1156dc6bb4e76c851cddd5bdff93e3c989e11417360bcfd51d061306bddca38a51d3be801e8316760c22b1e2959030e4d979b3e0acbcf3cc8e18e5868711c5d2bd8ba5285971dd646ad0903a25d02ca14b21d16673d5366e5a8c176700b97a769aa2a9826bae47ef95887ef21e4e191e317e855de53ccfa77a98f04806e7f494ff83f2c44ceda648e757e0c94f13e5efd31dcdff47d2439b97c124d5dd2d24f482efa52b48ec74e26f99ddbe1a15a5faf7f83f112785fb812f488b1f4ed94dd08261558a601fba0ee403e6075aad781896f38810db24ffa8911ab0a6ae6267948634a2cb4a7e07463843d9de363fc22eadb5c0f98e675ab0f817d4d99ef4b685ed0d5b2b6804bf5c74b4ab0fc4f672f7a217e68bb33a9da0d96748f541e941e46a09c523d1a784c").fromHex()
				console.log 'Sending [fake]: Length: ', message.length, message
				params.endpoint.write(message)
					
				###
				@authentication_service.send 
					method_id: 3
					request_id: params.request_id
					endpoint: params.endpoint
					message: logon_response
				###
	
	default_service: null
	connection_service: null
	authentication_service: null
	program: null
	
exports.acceptor = acceptor