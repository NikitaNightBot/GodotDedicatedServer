extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	name = str(get_multiplayer_authority())

@rpc("unreliable")
func remote_set_position(authority_position): pass

func _on_player_character_pressed():
	var id = get_multiplayer_authority()
	var packet_peer = multiplayer.multiplayer_peer.get_peer(id)
	packet_peer.peer_disconnect()
	queue_free()
