extends Control

@onready var option_button = $OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	option_button.modulate.a = 1.0
	
	
func _on_exit_button_pressed() -> void:
	queue_free()

func _reset_texture_rects(node):
	for child in node.get_children():
		if child is TextureRect:
			child.custom_minimum_size = Vector2(0, 0)
		_reset_texture_rects(child)
