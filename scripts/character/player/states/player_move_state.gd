extends PlayerState

var smoothed_blend_pos: Vector2 = Vector2.ZERO
var aimed_rotation: float

# Appelé quand on entre dans cet état
func enter() -> void:
	print("Enter move")
	var playback = player.anim_tree.get("parameters/StateMachine/playback")
	playback.travel("Move")

# Appelé quand on quitte cet état
func exit() -> void:
	print("Exit move")
	pass

# Appelé à chaque frame (comme _process)
func update(_delta: float) -> void:
	pass

# Appelé à chaque frame physique (comme _physics_process)
func physics_update(_delta: float) -> void:
	if player.controller.is_attack_pressed:
		state_machine.transition_to("Attack")
		return
	
	if player.controller.input_direction == Vector2.ZERO:
		state_machine.transition_to("Idle")
		return
	
	var relative_dir = player.camera.get_relative_direction_y(player.controller.input_direction);
	player.velocity.x = relative_dir.x * player.max_speed
	player.velocity.z = relative_dir.z * player.max_speed
	if player.camera.focused_target == null:
		aimed_rotation = Vector2(relative_dir.z, relative_dir.x).angle()
	else:
		var focused_target = player.camera.focused_target
		var direction_target = (focused_target.global_position - player.global_position).normalized()
		aimed_rotation = Vector2(direction_target.z, direction_target.x).angle()
	player.visual.rotation.y = lerp_angle(player.visual.rotation.y, aimed_rotation, _delta * 10.0)
	
	var local_dir = player.visual.global_transform.basis.inverse() * relative_dir
	var target_blend_pos = Vector2(local_dir.x, -local_dir.z)
	smoothed_blend_pos = smoothed_blend_pos.lerp(target_blend_pos, _delta * 10.0)
	player.anim_tree.set("parameters/StateMachine/Move/blend_position", smoothed_blend_pos)
