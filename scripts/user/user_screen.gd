extends Control

@onready var character_node = $Character

func _ready() -> void:
	UserService.load_or_create_user()
	
	update_character_skin()

func update_character_skin() -> void:
	var equipped_skin = UserService.get_equipped_skin()
	print("Skin saved in UserService: ", equipped_skin)

	var skin_path = "res://assets/characters/skins/" + equipped_skin + ".png"
	var default_path = "res://assets/characters/skins/default.png"
	var novo_tamanho = Vector2(250, 300)
	var texture_react = character_node

	if texture_react == null:
		push_error("ERROR: TextureButton not found inside Character Node!")
		return

	if ResourceLoader.exists(skin_path):
		texture_react.texture = load(skin_path)
		_apply_button_resizing(texture_react, novo_tamanho)
		print("Skin changed successfully!")
		return
	if ResourceLoader.exists(default_path):
		texture_react.texture = load(default_path)
		_apply_button_resizing(texture_react, novo_tamanho)
		print("Skin changed not found! Loading default..")
	else:
		push_error("ERROR: Skin path or any issue discovery")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/home.tscn")

func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/store.tscn")

func _on_skin_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/inventory.tscn")

func _apply_button_resizing(texture, size: Vector2) -> void:
	texture.ignore_texture_size = true
	texture.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	texture.custom_minimum_size = size
	texture.size = size

	texture.scale = Vector2(2.5, 2.5)
