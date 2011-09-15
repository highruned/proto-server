fs = require('fs')
proto_server = require('../../src/__init__')
proto_game = require('proto-game')

server = new proto_server.program()

server.set_descriptor(fs.readFileSync('all.descriptor'))

server.rebind_network
	'network.process_id': 'bnet.protocol.connection.ProcessId'
	'network.connection.service': 'bnet.protocol.connection.ConnectionService'
	'network.connection.connect_request': 'bnet.protocol.connection.ConnectRequest'
	'network.connection.connect_response': 'bnet.protocol.connection.ConnectResponse'
	'network.connection.bound_service': 'bnet.protocol.connection.BoundService'

connection_service = new proto_game.network.connection.service()

server.add_service(connection_service)

server.add_plugin(new proto_server.plugin.acceptor())

server.run()