class_name Enemy extends CharacterBody3D

var health: float = 30.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func take_damage(amount: float) -> void:
	if health <= 0:
		return
	
	health -= amount
	print("Aïe ! Il me reste ", health, " PV")
	
	if health <= 0:
		die()

func die():
	visible = false
