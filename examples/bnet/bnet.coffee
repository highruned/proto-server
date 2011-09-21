
fs = require('fs')
proto_server = require('../../src/__init__')
proto_game = require('proto-game')

server = new proto_server.program
	port: 1345
	descriptor: fs.readFileSync('all.descriptor')

# whisper service? 
# storage -> RemoteStorage
# rename all internal and external?
# LocalStorage

server.rebind_network
	'network.packet': 'custom.protocol.rpc.Packet'
	'network.varint': 'custom.protocol.rpc.Varint'
	'network.no_data': 'bnet.protocol.NoData'
	'network.process_id': 'bnet.protocol.connection.ProcessId'
	'network.variant': 'bnet.protocol.attribute.Variant'
	'network.attribute': 'bnet.protocol.attribute.Attribute'
	'network.attribute_filter': 'bnet.protocol.attribute.AttributeFilter'
	'network.connection.service': 'bnet.protocol.connection.ConnectionService'
	'network.connection.connect_request': 'bnet.protocol.connection.ConnectRequest'
	'network.connection.connect_response': 'bnet.protocol.connection.ConnectResponse'
	'network.connection.bind_request': 'bnet.protocol.connection.BindRequest'
	'network.connection.bind_response': 'bnet.protocol.connection.BindResponse'
	'network.connection.response.service': 'bnet.protocol.response.ResponseService'
	'network.connection.service': 'bnet.protocol.connection.ConnectionService'
	'network.connection.null_request': 'bnet.protocol.connection.NullRequest'
	'network.connection.encrypt_request': 'bnet.protocol.connection.EncryptRequest'
	'network.authentication.service': 'bnet.protocol.connection.AuthenticationService'
	'network.authentication.logon_request': 'bnet.protocol.authentication.LogonRequest'
	'network.authentication.logon_response': 'bnet.protocol.authentication.LogonResponse'
	'network.authentication.module_load_request': 'bnet.protocol.authentication.ModuleLoadRequest'
	'network.authentication.module_message_request': 'bnet.protocol.authentication.ModuleMessageRequest'
	'network.authentication.module_load_response': 'bnet.protocol.authentication.ModuleLoadResponse'
	'network.presence.service': 'bnet.protocol.presence.PresenceService'
	'network.presence.subscribe_request': 'bnet.protocol.presence.SubscribeRequest'
	'network.presence.unsubscribe_request': 'bnet.protocol.presence.UnsubscribeRequest'
	'network.presence.field_key': 'bnet.protocol.presence.FieldKey'
	'network.presence.field': 'bnet.protocol.presence.Field'
	'network.presence.field_operation': 'bnet.protocol.presence.FieldOperation'
	'network.presence.channel_state': 'bnet.protocol.presence.ChannelState'
	'network.game_master.service': 'bnet.protocol.game_master.GameMasterService'
	'network.game_master.game_stats_bucket': 'bnet.protocol.game_master.GameStatsBucket'
	'network.game_master.game_factory_description': 'bnet.protocol.game_master.GameFactoryDescription'
	'network.game_master.list_factories_request': 'bnet.protocol.game_master.ListFactoriesRequest'
	'network.game_master.list_factories_response': 'bnet.protocol.game_master.ListFactoriesResponse'
	'network.game_master.player': 'bnet.protocol.game_master.Player'
	'network.game_master.connection_info': 'bnet.protocol.game_master.ConnectionInfo'
	'network.game_master.game_stats_bucket': 'bnet.protocol.game_master.GameStatsBucket'
	'network.game_master.game_factory_description': 'bnet.protocol.game_master.GameFactoryDescription'
	'network.game_master.game_handle': 'bnet.protocol.game_master.GameHandle'
	'network.channel_invitation.service': 'bnet.protocol.channel_invitation.ChannelInvitationService'
	'network.channel_invitation.subscribe_request': 'bnet.protocol.channel_invitation.SubscribeRequest'
	'network.channel_invitation.subscribe_response': 'bnet.protocol.channel_invitation.SubscribeResponse'
	'network.toon.external.service': 'bnet.protocol.toon.external.ToonManagerService'
	'network.toon.external.toon_list_request': 'bnet.protocol.toon.external.ToonListRequest'
	'network.toon.external.toon_list_response': 'bnet.protocol.toon.external.ToonListResponse'
	'network.toon.external.select_request': 'bnet.protocol.toon.external.SelectToonRequest'
	'network.toon.external.select_response': 'bnet.protocol.toon.external.SelectToonResponse'
	'network.toon.service': 'bnet.protocol.toon.ToonManagerService'
	'network.party.service': 'bnet.protocol.party.PartyService'
	'network.party.create_channel': 'bnet.protocol.party.CreateChannel'
	'network.party.join_channel': 'bnet.protocol.party.JoinChannel'
	'network.party.get_channel_info': 'bnet.protocol.party.GetChannelInfo'
	'network.followers.service': 'bnet.protocol.followers.FollowersService'
	'network.followers.subscribe_to_followers_request': 'bnet.protocol.followers.SubscribeToFollowersRequest'
	'network.user_manager.service': 'bnet.protocol.user_manager.UserManagerService'
	'network.user_manager.subscribe_to_user_manager_request': 'bnet.protocol.user_manager.SubscribeToUserManagerRequest'
	'network.user_manager.subscribe_to_user_manager_response': 'bnet.protocol.user_manager.SubscribeToUserManagerResponse'
	'network.friends.service': 'bnet.protocol.friends.FriendsService'
	'network.friends.subscribe_to_friends_request': 'bnet.protocol.friends.SubscribeToFriendsRequest'
	'network.friends.subscribe_to_friends_response': 'bnet.protocol.friends.SubscribeToFriendsResponse'
	'network.game_utilities.service': 'bnet.protocol.game_utilities.GameUtilitiesService'
	'network.game_utilities.client_request': 'bnet.protocol.game_utilities.ClientRequest'
	'network.game_utilities.client_response': 'bnet.protocol.game_utilities.ClientResponse'
	'network.authentication_client.service': 'bnet.protocol.authentication_client.AuthenticationClientService'
	'network.notification.service': 'bnet.protocol.notification.NotificationService'
	'network.exchange.service': 'bnet.protocol.exchange.ExchangeService'
	'network.exchange.get_configuration_request': 'bnet.protocol.exchange.GetConfigurationRequest'
	'network.exchange.get_bid_fee_estimation_request': 'bnet.protocol.exchange.GetBidFeeEstimationRequest'
	'network.channel.service': 'bnet.protocol.channel.Channel' # doesn't suffix Service
	'network.channel_owner.service': 'bnet.protocol.channel.ChannelOwner' # doesn't suffix Service
	'network.channel_subscriber.service': 'bnet.protocol.channel.ChannelSubscriber' # doesn't suffix Service
	'network.chat.service': 'bnet.protocol.chat.ChatService'
	'network.storage.service': 'bnet.protocol.storage.StorageService'
	'network.storage.execute_request': 'bnet.protocol.storage.ExecuteRequest'
	'network.storage.execute_response': 'bnet.protocol.storage.ExecuteResponse'
	'network.storage.open_table_request': 'bnet.protocol.storage.OpenTableRequest'
	'network.storage.open_table_response': 'bnet.protocol.storage.OpenTableResponse'
	'network.storage.open_column_request': 'bnet.protocol.storage.OpenColumnRequest'
	'network.storage.open_column_response': 'bnet.protocol.storage.OpenColumnResponse'
	'network.storage.operation_result': 'bnet.protocol.storage.OperationResult'
	'network.search.service': 'bnet.protocol.search.SearchService'
	
	'network.game.entity_id': 'D3.OnlineService.EntityId'
	'network.game.hero.digest': 'D3.Hero.Digest'
	'network.game.hero.visual_equipment': 'D3.Hero.VisualEquipment'
	'network.game.hero.visual_item': 'D3.Hero.VisualItem'
	'network.game.hero.quest_history_entry': 'D3.Hero.QuestHistoryEntry'
	'network.game.account.banner_configuration': 'D3.OnlineService.EntityId'
	'network.game.account.digest': 'D3.Account.Digest'

server.add_service(new proto_game.network.connection.service())
server.add_service(new proto_game.network.response.service())
server.add_service(new proto_game.network.presence.service())
server.add_service(new proto_game.network.authentication.service())
server.add_service(new proto_game.network.channel.service())
server.add_service(new proto_game.network.channel_invitation.service())
server.add_service(new proto_game.network.channel_owner.service())
server.add_service(new proto_game.network.channel_subscriber.service())
server.add_service(new proto_game.network.toon.external.service())
server.add_service(new proto_game.network.followers.service())
server.add_service(new proto_game.network.friends.service())
server.add_service(new proto_game.network.party.service())
server.add_service(new proto_game.network.user_manager.service())
server.add_service(new proto_game.network.game_master.service())
server.add_service(new proto_game.network.game_utilities.service())
server.add_service(new proto_game.network.followers.service())
server.add_service(new proto_game.network.notification.service())
server.add_service(new proto_game.network.exchange.service())
server.add_service(new proto_game.network.chat.service())
server.add_service(new proto_game.network.storage.service())
server.add_service(new proto_game.network.search.service())

server.add_plugin(new proto_server.plugin.acceptor())

server.run()
	
