extends Button

@export var pressed_scale := Vector2(0.92, 0.92)
@export var animation_speed := 0.08

func _ready():
	pivot_offset = size / 2

	connect("button_down", _on_button_down)
	connect("button_up", _on_button_up)
	connect("mouse_exited", _on_mouse_exited)


func _on_button_down():
	animate_to(pressed_scale)


func _on_button_up():
	animate_to(Vector2.ONE)


func _on_mouse_exited():
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		animate_to(Vector2.ONE)


func animate_to(target_scale: Vector2):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", target_scale, animation_speed)
