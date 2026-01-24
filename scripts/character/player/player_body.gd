class_name PlayerBody extends CharacterBody

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var jump_velocity = 4.5
@export var max_speed = 5.0

@onready var player_controller: PlayerController = $"../PlayerController"

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	player_controller.direction_changed.connect(set_direction)
	player_controller.want_jump.connect(jump)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func set_direction(direction: Vector2):
	self.direction = direction

func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
