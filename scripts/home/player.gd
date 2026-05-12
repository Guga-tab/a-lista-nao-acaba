extends CharacterBody2D

@export var speed: float = 250.0

@onready var sprites = {
	"default": $default,
	"garden": $garden,
	"purple_pink": $purple_pink,
	"natal": $natal,
	"black_manba": $black_manba
}

var animated_sprite: AnimatedSprite2D

var last_direction: Vector2 = Vector2.DOWN  # direção padrão (idle sul)

func _ready():
	load_equipped_skin()

func _physics_process(delta):
	var direction = Vector2.ZERO

	# input
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")

	# normaliza
	direction = direction.normalized()

	# movimento
	velocity = direction * speed
	move_and_slide()

	# animação
	update_animation(direction)


func update_animation(direction: Vector2):
	# parado → idle
	if direction == Vector2.ZERO:
		play_idle()
		return

	# guarda última direção
	last_direction = direction

	# prioridade: eixo dominante
	if abs(direction.x) > abs(direction.y):
		# horizontal
		if direction.x > 0:
			animated_sprite.play("walk_e")  # leste
			animated_sprite.flip_h = false
		else:
			animated_sprite.play("walk_w")  # oeste
			animated_sprite.flip_h = false
	else:
		# vertical
		if direction.y > 0:
			animated_sprite.play("walk_s")  # sul
		else:
			animated_sprite.play("walk_n")  # norte


func play_idle():
	# usa última direção pra decidir idle
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
			
			
func load_equipped_skin():

	# pega skin equipada
	var equipped_skin = UserService.get_equipped_skin()

	# fallback
	if equipped_skin == "" or equipped_skin == null:
		equipped_skin = "default"

	# esconde todos
	for sprite in sprites.values():
		sprite.visible = false

	# ativa o equipado
	animated_sprite = sprites[equipped_skin]
	animated_sprite.visible = true
