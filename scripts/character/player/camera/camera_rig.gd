class_name CameraRig extends Node3D

@export var sensitivity: float = 3.0
@export_range(-90.0, 0.0, 0.1, "radians_as_degrees") var min_pitch: float = -PI/2
@export_range(0.0, 90.0, 0.1, "radians_as_degrees") var max_pitch: float = 0.3
@export_flags_3d_physics var wall_layer: int;

@export var player: Player;
@export var player_mesh: MeshInstance3D;

@onready var yaw: Node3D = $Yaw
@onready var pitch: Node3D = $Yaw/Pitch
@onready var spring_arm: SpringArm3D = $Yaw/Pitch/SpringArm3D
@onready var camera: Camera3D = $Yaw/Pitch/Camera3D
@onready var shape_cast_3D: ShapeCast3D = $Yaw/Pitch/Camera3D/ShapeCast3D

var player_height: float;
var player_center: Vector3;
var og_pos;
var focused_target: Node3D = null
var is_recentering: bool = false

var walls: Array[MeshInstance3D] = [];

func _ready() -> void:
	og_pos = global_position - player.global_position
	player_height = player_mesh.get_aabb().size.y * player_mesh.scale.y
	player_center = player.global_position
	player_center.y = player_height / 2
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	sensitivity = sensitivity / 1000
	
	player.controller.on_camera_focus.connect(focus_or_recenter)

func _input(event: InputEvent) -> void:
	if event is InputEventMouse && event.is_pressed() && event.button_index == MOUSE_BUTTON_RIGHT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and focused_target == null and !is_recentering:
		yaw.rotation.y -= event.relative.x * sensitivity
		yaw.rotation.y = wrapf(yaw.rotation.y, 0.0, TAU)
		
		pitch.rotation.x -= event.relative.y * sensitivity
		pitch.rotation.x = clamp(pitch.rotation.x, min_pitch, max_pitch)

func _physics_process(delta):
	global_position = player.global_position + og_pos
	
	var target_direction = Vector3.ZERO
	var is_rotating_camera = false
	
	if is_instance_valid(focused_target):
		target_direction = (global_position - focused_target.global_position).normalized()
		is_rotating_camera = true
	elif is_recentering:
		target_direction = -player.visual.basis.z.normalized()
		is_rotating_camera = true
	
	if is_rotating_camera:
		var aimed_rotation_yaw = Vector2(target_direction.z, target_direction.x).angle()
		yaw.rotation.y = lerp_angle(yaw.rotation.y, aimed_rotation_yaw, delta * 5.0)
		
		var distance_horizontale = Vector2(target_direction.x, target_direction.z).length()
		var aimed_rotation_pitch = atan2(target_direction.y, distance_horizontale)
		pitch.rotation.x = lerp_angle(pitch.rotation.x, -aimed_rotation_pitch, delta * 5.0)
		pitch.rotation.x = clamp(pitch.rotation.x, min_pitch, max_pitch)
		
		var is_centered = abs(angle_difference(aimed_rotation_yaw, yaw.rotation.y)) < 0.05 && abs(angle_difference(aimed_rotation_pitch, pitch.rotation.x)) < 0.05
		if is_recentering && is_centered:
			is_recentering = false
	   
	transparency_wall_between_player_and_camera()

func focus_or_recenter():
	if focused_target:
		unfocus_camera()
	else:
		var enemies = get_visible_enemies()
		if enemies.size() > 0:
			focus_camera_on(enemies[0])
		else:
			trigger_recenter()

func trigger_recenter():
	if is_recentering: return
	focused_target = null
	is_recentering = true

func focus_camera_on(target: Node3D):
	is_recentering = false # On coupe le recentrage s'il était en cours
	focused_target = target # On mémorise le nœud qui bouge

func unfocus_camera():
	focused_target = null;

func get_visible_enemies():
	var visible_elements = []
	var camera = get_viewport().get_camera_3d()
	
	# On itère sur un groupe d'objets spécifiques
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		if camera.is_position_in_frustum(enemy.global_position):
			visible_elements.append(enemy)
	
	return visible_elements

func get_relative_direction_y(direction: Vector2):
	return Vector3(direction.x, 0.0, direction.y).rotated(Vector3.UP, camera.global_rotation.y)

func transparency_wall_between_player_and_camera():
	var bottom = player.global_position
	var top = bottom + Vector3.UP * player_height
	
	for wall in walls:
		var mat = wall.get_active_material(0)
		mat.set_shader_parameter("target_bottom", bottom)
		mat.set_shader_parameter("target_top", top)
		mat.set_shader_parameter("fade_enabled", false)
	
	walls.clear()
	shape_cast_3D.force_shapecast_update()
	for i in range(shape_cast_3D.get_collision_count()):
		var collider = shape_cast_3D.get_collider(i)
		if collider and collider.get_parent() is MeshInstance3D:
			var wall: MeshInstance3D = collider.get_parent()
			walls.push_back(wall)
			var mat = wall.get_active_material(0)
			if mat:
				mat.set_shader_parameter("fade_enabled", true)
