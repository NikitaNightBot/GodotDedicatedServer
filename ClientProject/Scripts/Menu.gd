extends VBoxContainer

var multiplayer_peer = ENetMultiplayerPeer.new()

var connected_peer_ids = []
var local_player_character

@onready var world = get_parent().get_node("World")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_join_pressed():
	visible = false
	var response = multiplayer_peer.create_client(
		$AdressInput.text,
		$PortInput.text.to_int()
	)
	if response == OK:
		print("Client created succesfully :D")
		multiplayer.multiplayer_peer = multiplayer_peer
		world.visible = true
	elif response == ERR_CANT_CREATE:
		print("Cant create client")
	elif response == ERR_ALREADY_IN_USE:
		print("Already in use (?)")
	

func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://Scenes/Player_character.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	world.add_child(player_character)
	if peer_id == multiplayer.get_unique_id():
		local_player_character = player_character

@rpc	
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)

@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)

