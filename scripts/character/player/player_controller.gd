class_name PlayerController extends Node3D

signal direction_changed(direction: Vector2)
signal want_jump()

var current_direction: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Jump"):
		want_jump.emit()

func _physics_process(_delta: float) -> void:
	var input_dir := Vector2.ZERO
	
	input_dir = Input.get_vector("Left", "Right", "Forward", "Backward");
	
	input_dir = input_dir.normalized()
	
	if input_dir != current_direction:
		current_direction = input_dir
		direction_changed.emit(current_direction)
