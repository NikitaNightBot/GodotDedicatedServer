extends Control

var multiplayer_peer = ENetMultiplayerPeer.new()

var connected_peer_ids = []

func _on_start_pressed():
	multiplayer_peer.create_server(
		$Menu/PortInput.text.to_int(),
		$Menu/MaxPlayersInput.text.to_int()
	)
	multiplayer.multiplayer_peer = multiplayer_peer
	
	multiplayer_peer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1).timeout
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
			
			rpc("add_newly_connected_player_character", new_peer_id)
			add_player_character(new_peer_id)
	)
	
	$Menu.visible = false
	
func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://Scenes/Player_character.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)

@rpc("call_remote")
func add_newly_connected_player_character(new_peer_id):
	pass

@rpc("call_remote")
func add_previously_connected_player_characters(peer_ids):
	pass
