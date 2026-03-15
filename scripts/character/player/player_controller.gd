class_name PlayerController extends Node3D

signal on_camera_focus()

var input_direction: Vector2 = Vector2.ZERO
var is_jump_pressed: bool = false
var is_attack_pressed: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("CameraFocus"):
		on_camera_focus.emit()

func _physics_process(_delta: float) -> void:
	# On met à jour la direction en permanence
	input_direction = Input.get_vector("Left", "Right", "Forward", "Backward").normalized()
	
	# On lit si le saut vient d'être pressé
	is_jump_pressed = Input.is_action_just_pressed("Jump")
	
	is_attack_pressed = Input.is_action_just_pressed("Attack")
