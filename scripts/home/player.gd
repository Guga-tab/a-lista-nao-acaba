extends CharacterBody2D

@export var speed: float = 250.0

func _physics_process(delta):
	var direction = Vector2.ZERO

	# Movimento horizontal
	direction.x = Input.get_axis("ui_left", "ui_right")

	# Movimento vertical
	direction.y = Input.get_axis("ui_up", "ui_down")

	# Normaliza diagonal
	direction = direction.normalized()

	velocity = direction * speed

	move_and_slide()
