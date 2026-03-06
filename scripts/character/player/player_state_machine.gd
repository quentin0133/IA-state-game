class_name PlayerStateMachine extends Node

@export var initial_state: PlayerState
var current_state: PlayerState

func _ready() -> void:
	# On donne à tous les états enfants la référence du joueur et du contrôleur
	var player = owner as Player # 'owner' est la racine de la scène (Player)

	for child in get_children():
		if child is PlayerState:
			child.player = player
			child.state_machine = self

	# On initialise le premier état (Grounded)
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

# C'est LA fonction pour changer d'état (ex: passer de Idle à Attack)
func transition_to(new_state_name: String) -> void:
	var new_state = get_node(new_state_name)
	if new_state == null or new_state == current_state:
		return
	
	current_state.exit()
	new_state.enter()
	current_state = new_state
