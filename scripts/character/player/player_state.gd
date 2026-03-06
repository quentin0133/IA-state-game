class_name PlayerState extends Node

var player: Player
var state_machine: PlayerStateMachine

# Appelé quand on entre dans cet état
func enter() -> void:
	pass

# Appelé quand on quitte cet état
func exit() -> void:
	pass

# Appelé à chaque frame (comme _process)
func update(_delta: float) -> void:
	pass

# Appelé à chaque frame physique (comme _physics_process)
func physics_update(_delta: float) -> void:
	pass
