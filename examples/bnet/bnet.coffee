fs = require('fs')
proto_server = require('../../src/__init__')
proto_game = require('proto-game')

server = new proto_server.program()

server.set_descriptor(fs.readFileSync('all.descriptor'))

server.rebind_network
	'network.process_id': 'bnet.protocol.connection.ProcessId'
	'network.service': 'bnet.protocol.connection.ConnectionService'
	'network.connect_request': 'bnet.protocol.connection.ConnectRequest'
	'network.connect_response': 'bnet.protocol.connection.ConnectResponse'
	'network.bind_request': 'bnet.protocol.connection.BindRequest'
	'network.bind_response': 'bnet.protocol.connection.BindResponse'
	'network.connection.service': 'bnet.protocol.connection.ConnectionService'
	'network.connection.null_request': 'bnet.protocol.connection.NullRequest'
	'network.connection.encrypt_request': 'bnet.protocol.connection.EncryptRequest'
	'network.authentication.logon_request': 'bnet.protocol.authentication.LogonRequest'
	'network.authentication.logon_response': 'bnet.protocol.authentication.LogonResponse'

server.add_service(new proto_game.network.service())
server.add_service(new proto_game.network.connection.service())
server.add_service(new proto_game.network.authentication.service())

server.add_plugin(new proto_server.plugin.acceptor())

server.run()