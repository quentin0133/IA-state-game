extends Camera3D

@export var spring_arm: Node3D
@export var lerp_power: float = 6.0
@export var target: Node3D
@export var min_distance = 2.0

func _physics_process(delta: float) -> void:
	var target_pos = target.position
	var spring_arm_pos = spring_arm.position
	var fade_position = lerp(position, spring_arm_pos, delta * lerp_power);
	var dir = (spring_arm_pos - target_pos).normalized()
	
	var dist = target_pos.distance_to(fade_position)
	dist = max(dist, min_distance)
	
	position = target_pos + dir * dist
