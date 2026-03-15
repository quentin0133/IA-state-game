class_name Hurtbox extends Area3D

func take_damage(amount: float) -> void:
	# 'owner' est la racine de la scène (ex: EnemyBody)
	if owner.has_method("take_damage"):
		owner.take_damage(amount)
