extends CharacterBody2D

@export var speed: float = 250.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.DOWN

func _physics_process(delta):
	var direction = Vector2.ZERO

	# input
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")

	# normalize
	direction = direction.normalized()

	# move
	velocity = direction * speed
	move_and_slide()

	# animation
	update_animation(direction)


func update_animation(direction: Vector2):
	# idle
	if direction == Vector2.ZERO:
		play_idle()
		return

	last_direction = direction

	if abs(direction.x) > abs(direction.y):
		# horizontal
		if direction.x > 0:
			animated_sprite.play("walk_e")  # east
			animated_sprite.flip_h = false
		else:
			animated_sprite.play("walk_w")  # west
			animated_sprite.flip_h = false
	else:
		# vertical
		if direction.y > 0:
			animated_sprite.play("walk_s")  # south
		else:
			animated_sprite.play("walk_n")  # north

func play_idle():
	if abs(last_direction.x) > abs(last_direction.y):
		if last_direction.x > 0:
			animated_sprite.play("idle_e")
		else:
			animated_sprite.play("idle_w")
	else:
		if last_direction.y > 0:
			animated_sprite.play("idle_s")
		else:
			animated_sprite.play("idle_n")
