game = require('proto-game')
plugin = game.plugin
network = game.network
assert = require('assert')
util = require('util')

class acceptor extends plugin
	constructor: (@program) ->
		if @program
			@set_program(@program)
	
	set_program: (@program) ->
		@program.on 'initialized', () =>
		
			response_service = @program.get_service('network.response.service')
			
			response_service.on 'handle_request', (message) =>
				console.log 'Something bad happened.', message
				
			connection_service = @program.get_service('network.connection.service')
		
			connection_service.on 'disconnect_notification', (message) =>
				console.log 'Disconnecting.', message
				
			connection_service.on 'connect_request', (message) =>
				connect_response = new network.connection.connect_response
					client_id: message.endpoint.id
					server_id: @program.id

				response_service.send 
					request_id: 0
					endpoint: message.endpoint
					payload: connect_response
			
			connection_service.on 'bind_request', (message) =>
				services = []
				imported_service_id = []
				
				console.log message.payload
				
				console.log "Trying to find services: "
				
				for service_hash, key in message.payload.imported_service_hash
					console.log '0x' + service_hash.toString(16)
				
				# improper
				for service_hash, key in message.payload.imported_service_hash
					service = @program.get_service_by_hash(service_hash)
					
					if !service
						console.error "Could not find service, by hash: ", service_hash.toString(16)
						process.exit 1
					
					console.log "Binding: Service Name: ", service?.name, " Service Hash: 0x" + service_hash.toString(16), " Service ID: ", service?.id
					
					if !service
						continue
					
					imported_service_id.push(service.id)
				
				assert.equal(imported_service_id.length, message.payload.imported_service_hash.length)
				
				### proper
				# our friend the client wants some services attached to his instance
				message.endpoint.add_service(exported_service)
				
				bind_response = new network.connection.bind_response
					imported_service_id: imported_service_id
				###
				
				bind_response = new network.connection.bind_response
					imported_service_id: imported_service_id
				
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: bind_response
				
			
			authentication_service = @program.get_service('network.authentication.service')
			
			authentication_service.on 'logon_request', (message) =>
				console.log message.payload
				
				# find accounts in db
				message.endpoint.account = new network.entity_id
					low: 0
					high: 0x100000000000000
				
				message.endpoint.game_account = new network.entity_id
					low: 0
					high: 0x200006200004433
			
				# send accounts to client
				logon_response = new network.authentication.logon_response
					account: message.endpoint.account
					game_account: message.endpoint.game_account
				
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: logon_response
			
			authentication_service.on 'module_load_request', (message) =>
			
			
				return # ignore proper auth process for now
				
				module_load_request = new network.authentication.module_load_request
					module_id: 0
					message: "\003\372\310Z\320a}\367\316\022\2463\214W\036<G\371m$;\222:6\255y\242\203!\021\247\345\272\231<k\0233\030\256\271\017\007\330{\007\355\205\253H\213\303\367Oa\234\004;OJ\247\235\277\236z\321\264\\$U\3444t\321@\260\032?O\213-\316\340E\367\"\364\325J\335\271\215G\302\327\353*\237iN\344\r\021\201\016\320\324y\370_f\322*DL\013\006,\177n\2622\010\324=\371\3349\222\276\224\224\026$\036\237\314[\205\274\251\336\225q\\\212&\221\014\222\035\350v\213\305\253?D\003E\034"
				
				authentication_service.send 
					method_id: 1
					request_id: message.request_id
					endpoint: message.endpoint
					payload: module_load_request	
				
				
			channel_invitation_service = @program.get_service('network.channel_invitation.service')
			
			channel_invitation_service.on 'subscribe_request', (message) =>
				console.log message
				# getting object id 43 here.. no idea
			
				#service = @program.get_service_by_id(message.payload.object_id)
				
				#service.add_subscriber(@program.get_client_by_account(message.payload.entity_id))
			
				#subscribe_response = new network.channel_invitation_service.subscribe_response
				#	entity_id: message.payload.entity_id
				
				subscribe_response = new network.no_data
				
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: subscribe_response
				
			party_service = @program.get_service('network.party.service')
			
			party_service.on 'create_channel_request', (message) =>
				create_channel_response = new network.party.create_channel_response
					object_id: message.payload.object_id
					channel_id: new network.entity_id
						high: 0xccdd
						low: 0xaabb
				
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: create_channel_response	
				
				
			toon_external_service = @program.get_service('network.toon.external.service')
			
			toon_external_service.on 'toon_list_request', (message) =>
				toon_list_response = new network.toon.external.toon_list_response
					toons: message.endpoint.toons
					
				###
				,
				new network.entity_id
					high: 216174302532224051
					low: 14655650672318688456
				###
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: toon_list_response	
			
			toon_external_service.on 'select_request', (message) =>
				console.log message
			
				select_response = new network.toon.external.select_response
					toons: message.endpoint.toons

				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: select_response	
			
			
			followers_service = @program.get_service('network.followers.service')
			
			followers_service.on 'subscribe_to_followers_request', (message) =>
				subscribe_to_followers_response = new network.no_data
				
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: subscribe_to_followers_response	
					
				
			followers_service.on 'subscribe_to_user_manager_request', (message) =>
				subscribe_to_user_manager_response = new network.no_data
				
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: subscribe_to_user_manager_response	
					
			
			friends_service = @program.get_service('network.friends.service')
			
			friends_service.on 'subscribe_to_friends_request', (message) =>
				subscribe_to_friends_response = new network.friends.subscribe_to_friends_response
					max_friends: 127
					max_received_invitations: 127
					max_sent_invitations: 127
				
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: subscribe_to_friends_response	
				
			
			exchange_service = @program.get_service('network.exchange.service')
			
			exchange_service.on 'get_bid_fee_estimation_request', (message) =>
				get_bid_fee_estimation_response = new network.exchange.get_bid_fee_estimation_response
					fee_amount: 999999999
				
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: get_bid_fee_estimation_response	


			presence_service = @program.get_service('network.presence.service')
			
			presence_service.on 'subscribe_request', (message) =>
				console.log message

				#service = @program.get_service_by_id(message.payload.object_id)
				
				#service.add_subscriber(@program.get_client_by_account(message.payload.entity_id))
			
				#subscribe_response = new network.channel_invitation_service.subscribe_response
				#	entity_id: message.payload.entity_id
				
				subscribe_response = new network.no_data
				
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: subscribe_response


			user_manager_service = @program.get_service('network.user_manager.service')
			
			user_manager_service.on 'subscribe_to_user_manager_request', (message) =>
				subscribe_to_user_manager_response = new network.user_manager.subscribe_to_user_manager_request
					blocked_users: [
					]
					recent_players: [
 						player: new network.entity_id
							high: 216174302532224051
							low: 10824503355229695733
						timestamp_played: (new Date()).getTime()
						attributes: [
						]
					]

				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: subscribe_to_user_manager_response 	
 				
			game_master_service = @program.get_service('network.game_master.service')
			
			game_master_service.on 'list_factories_request', (message) =>
				console.log message
				
				factories = []
				
				attr1 = new network.attribute
					name: "min_players"
					value: new network.variant
						int_value: 2
					
				attr2 = new network.attribute
					name: "max_players"
					value: new network.variant
						int_value: 4
					
				attr3 = new network.attribute
					name: "num_teams"
					value: new network.variant
						int_value: 1
					
				attr4 = new network.attribute
					name: "version"
					value: new network.variant
						string_value: "0.3.0"
	
				stats = new network.game_master.game_stats_bucket
					bucket_min: 0
					bucket_max: 4267296
					wait_milliseconds: 1354
					games_per_hour: 0
					active_games: 50
					active_players: 60
					forming_games: 0
					waiting_players: 0
	
				factory = new network.game_master.game_factory_description 
					id: 14249086168335147635 # CoopFactoryID - 14249086168335147635 was value on bnet forum error log
					stats_bucket: [
						stats
					]
					attribute: [
						attr1,
						attr2,
						attr3,
						attr4
					]
				console.log factory
				factories.push(factory)
				
				list_factories_response = new network.game_master.list_factories_response
					total_results: 1
					description: factories

				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: list_factories_response	

			storage_service = @program.get_service('network.storage.service')
			
			storage_service.on 'execute_request', (message) =>
				console.log util.inspect(message.payload, true, 5)
				
				message.payload.query_name = message.payload.query_name.to_underscore()
				
				if !storage_service[message.payload.query_name]
					console.error "Storage method does not exist: ", message.payload.query_name
					
					process.exit 1
				
				operation_results = storage_service[message.payload.query_name](message)
				
				execute_response = new network.storage.execute_response
					results: operation_results

				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: execute_response
			
			storage_service.on 'open_table_request', (message) =>
				console.log message
				
				open_table_response = new network.storage.open_table_response
				
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: open_table_response
			
			storage_service.on 'open_column_request', (message) =>
				console.log message
				
				open_column_response = new network.storage.open_column_response
				
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: open_column_response
				
			game_utilities_service = @program.get_service('network.game_utilities.service')
			
			game_utilities_service.on 'client_request', (message) =>
				console.log message

				client_response = new network.game_utilities.client_response
					attribute: message.payload.attribute
					
				response_service.send 
					request_id: message.request_id
					endpoint: message.endpoint
					payload: client_response
	
	default_service: null
	connection_service: null
	authentication_service: null
	program: null
	
exports.acceptor = acceptor