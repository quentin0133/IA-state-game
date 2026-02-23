class_name PlayerBody extends CharacterBody

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var jump_velocity = 4.5
@export var max_speed = 5.0

@export var player_controller: PlayerController
@export var camera: CameraRig

var input_dir: Vector2 = Vector2.ZERO
var aimed_rotation = 0.0;

func _ready() -> void:
	player_controller.input_dir_changed.connect(set_input_dir)
	player_controller.want_jump.connect(jump)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if input_dir != Vector2.ZERO:
		var relative_dir = camera.get_relative_direction_y(input_dir);
		velocity.x = relative_dir.x * SPEED
		velocity.z = relative_dir.z * SPEED
		aimed_rotation = Vector2(relative_dir.z, relative_dir.x).angle()
		rotation.y = rotate_toward(rotation.y, aimed_rotation, delta * 5.0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func set_input_dir(input_dir: Vector2):
	self.input_dir = input_dir

func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
