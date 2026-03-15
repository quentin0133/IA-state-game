extends PlayerState

func enter() -> void:
	# On calcule l'avant du joueur en fonction de sa rotation visuelle
	var forward_direction = player.visual.global_transform.basis.z 
	
	# On lui donne une petite impulsion vers l'avant (Ajuste la valeur 10.0 selon ton échelle)
	player.velocity = forward_direction * 10.0 
	
	var playback = player.anim_tree.get("parameters/StateMachine/playback")
	playback.travel("Attack")

func exit():
	print("Exit attack")

func physics_update(_delta: float) -> void:
	# On garde la gravité au cas où le joueur attaque dans le vide et tombe d'un rebord !
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * _delta
	
	# On freine cette impulsion très vite pour faire un effet de "freinage sec"
	# (Ajuste le 20.0 pour un freinage plus ou moins glissant)
	player.velocity.x = move_toward(player.velocity.x, 0, player.max_speed * 20.0 * _delta)
	player.velocity.z = move_toward(player.velocity.z, 0, player.max_speed * 20.0 * _delta)
	
	player.move_and_slide()
