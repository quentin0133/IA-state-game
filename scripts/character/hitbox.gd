extends Area3D

@export var damage: float = 10.0

var hit_entities: Array[Area3D] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	if area in hit_entities:
		return
	
	if area.has_method("take_damage"):
		area.take_damage(damage)
		hit_entities.append(area)

func clear_hit_list() -> void:
	hit_entities.clear()
