extends CharacterBody2D

@export var speed: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	name = str(get_multiplayer_authority())
	$Label.text = "[center]"+str(name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_multiplayer_authority():
			
		var direction:Vector2 = Vector2.ZERO
		
		if Input.is_key_pressed(KEY_W): direction.y -= 1
		if Input.is_key_pressed(KEY_S): direction.y += 1
		if Input.is_key_pressed(KEY_A): direction.x -= 1
		if Input.is_key_pressed(KEY_D): direction.x += 1
		
		global_position += direction.normalized()
		rpc("remote_set_position", global_position)
		
@rpc("unreliable")
func remote_set_position(authority_position):
	global_position = authority_position
