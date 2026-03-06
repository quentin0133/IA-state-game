extends PlayerState

var SPEED = 4.5

# Appelé quand on entre dans cet état
func enter() -> void:
	print("Enter idle")
	var playback = player.anim_tree.get("parameters/StateMachine/playback")
	playback.travel("Idle")

# Appelé quand on quitte cet état
func exit() -> void:
	print("Exit idle")
	pass

# Appelé à chaque frame (comme _process)
func update(_delta: float) -> void:
	pass

# Appelé à chaque frame physique (comme _physics_process)
func physics_update(_delta: float) -> void:
	if player.controller.input_direction != Vector2.ZERO:
		state_machine.transition_to("Move")
		return
	
	player.velocity.x = move_toward(player.velocity.x, 0, player.max_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.max_speed)
