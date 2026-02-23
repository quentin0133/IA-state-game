class_name CameraRig extends Node3D

@export var sensitivity: float = 3.0
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var min_pitch: float = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var max_pitch: float = 0.3
@export_flags_3d_physics var wall_layer: int;

@export var player: Node3D;
@export var player_mesh: MeshInstance3D;

@onready var yaw: Node3D = $Yaw
@onready var pitch: Node3D = $Yaw/Pitch
@onready var spring_arm: SpringArm3D = $Yaw/Pitch/SpringArm3D
@onready var camera: Camera3D = $Yaw/Pitch/Camera3D
@onready var shape_cast_3D: ShapeCast3D = $Yaw/Pitch/Camera3D/ShapeCast3D

var player_height: float;
var player_center: Vector3;
var og_pos;

var walls: Array[MeshInstance3D] = [];

func _ready() -> void:
	og_pos = global_position - player.global_position
	player_height = player_mesh.get_aabb().size.y * player_mesh.scale.y
	player_center = player.global_position
	player_center.y = player_height / 2
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	sensitivity = sensitivity / 1000

func _input(event: InputEvent) -> void:
	if event is InputEventMouse && event.is_pressed() && event.button_index == MOUSE_BUTTON_RIGHT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw.rotation.y -= event.relative.x * sensitivity
		yaw.rotation.y = wrapf(yaw.rotation.y, 0.0, TAU)
		
		pitch.rotation.x -= event.relative.y * sensitivity
		pitch.rotation.x = clamp(pitch.rotation.x, min_pitch, max_pitch)

func get_relative_direction_y(direction: Vector2):
	return Vector3(direction.x, 0.0, direction.y).rotated(Vector3.UP, camera.global_rotation.y)

func _process(delta):
	global_position = player.global_position + og_pos
	transparency_wall_between_player_and_camera();

func transparency_wall_between_player_and_camera():
	var bottom = player.global_position
	var top = bottom + Vector3.UP * player_height
	
	for wall in walls:
		var mat = wall.get_active_material(0)
		mat.set_shader_parameter("target_bottom", bottom)
		mat.set_shader_parameter("target_top", top)
		mat.set_shader_parameter("fade_enabled", false)
	
	walls.clear()
	for result in shape_cast_3D.collision_result:
		if result && result.collider && result.collider.get_parent() is MeshInstance3D:
			var wall: MeshInstance3D = result.collider.get_parent();
			walls.push_back(wall)
			var mat = wall.get_active_material(0)
			mat.set_shader_parameter("fade_enabled", true)
