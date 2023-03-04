extends VBoxContainer

var multiplayer_peer = ENetMultiplayerPeer.new()

var connected_peer_ids = []

@onready var world = get_parent().get_node("World")

func _on_start_pressed():
	var upnp = UPNP.new()
	upnp.discover()
	upnp.add_port_mapping($PortInput.text.to_int())
	await get_tree().create_timer(3).timeout
	if multiplayer_peer.create_server(
		$PortInput.text.to_int(),
		$MaxPlayersInput.text.to_int()
	) == OK:
		multiplayer_peer.set_bind_ip($AdressInput.text)
		multiplayer.multiplayer_peer = multiplayer_peer
		
		multiplayer_peer.peer_connected.connect(
			func(new_peer_id):
				await get_tree().create_timer(1).timeout
				rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
				
				rpc("add_newly_connected_player_character", new_peer_id)
				add_player_character(new_peer_id)
		)
	
		visible = false
	else:
		print("Failed to open server")
	
func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://Scenes/Player_character.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	world.add_child(player_character)

@rpc("call_remote")
func add_newly_connected_player_character(new_peer_id):
	pass

@rpc("call_remote")
func add_previously_connected_player_characters(peer_ids):
	pass
