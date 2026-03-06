class_name Player extends CharacterBody

@export var max_speed: float = 4.5

@export var controller: PlayerController
@export var visual: Node3D
@export var camera: CameraRig
@export var anim_tree: AnimationTree

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
