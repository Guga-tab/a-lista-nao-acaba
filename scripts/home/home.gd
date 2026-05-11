extends Control

@onready var character_node = $Character

# Rooms
@onready var deco_bedroom = $Bg/Room/Bedroom
@onready var deco_living_room = $Bg/Room/LivingRoom
@onready var deco_toilet = $Bg/Room/Toilet
@onready var deco_kitchen = $Bg/Room/Kitchen

# Nodes of scene
@onready var ConfigScreen = preload("res://scenes/pop_ups/config.tscn")
@onready var coin_label = $Bg/Coin/CoinLabel
@onready var click_sound = $click_sound

func _ready():
	# Up services
	UserService.load_or_create_user()
	
	if not UserService.skin_changed.is_connected(_on_skin_changed):
		UserService.skin_changed.connect(_on_skin_changed)
	
	# Initial load (Skins and Decorations) 
	update_character_skin()
	apply_equipped_decorations()
	
	# Update main UI
	update_coin_label()

func _on_skin_changed(_new_skin_name: String):
	update_character_skin()

func update_coin_label():
	var coins = UserService.get_coins()
	coin_label.text = str(coins)

func _on_config_button_pressed() -> void:
	click_sound.play()
	var config_screen = ConfigScreen.instantiate()
	add_child(config_screen)

# Update character skin and size
func update_character_skin() -> void:
	var equipped_skin = UserService.get_equipped_skin()
	#Debug
	print("Skin saved in UserService: ", equipped_skin)

	var skin_path = "res://assets/characters/skins/" + equipped_skin + ".png"
	var default_path = "res://assets/characters/skins/default.png"
	var novo_tamanho = Vector2(150, 250)

	var texture_button = character_node.get_node("TextureButton") as TextureButton

	if texture_button == null:
		#Debug
		push_error("ERROR: TextureButton not found inside Character Node!")
		return

	texture_button.texture_normal = null
	
	if ResourceLoader.exists(skin_path):
		texture_button.texture_normal = load(skin_path)
		_apply_button_resizing(texture_button, novo_tamanho)
		print("Skin changed successfully!")
	elif ResourceLoader.exists(default_path):
		texture_button.texture_normal = load(default_path)
		_apply_button_resizing(texture_button, novo_tamanho)
		print("Skin changed not found! Loading default...")
	else:
		push_error("ERROR: Skin path or any issue discovery")

# Show/Hide Decorations
func apply_equipped_decorations() -> void:
	var equipped_decorations = UserService.get_equipped_decorations()

	if deco_bedroom: deco_bedroom.visible = false
	if deco_living_room: deco_living_room.visible = false
	if deco_toilet: deco_toilet.visible = false
	if deco_kitchen: deco_kitchen.visible = false

	if "bedroom" in equipped_decorations and deco_bedroom:
		deco_bedroom.visible = true
	if "living_room" in equipped_decorations and deco_living_room:
		deco_living_room.visible = true
	if "toilet" in equipped_decorations and deco_toilet:
		deco_toilet.visible = true
	if "kitchen" in equipped_decorations and deco_kitchen:
		deco_kitchen.visible = true

func _apply_button_resizing(button: TextureButton, size: Vector2) -> void:
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.custom_minimum_size = size
	button.size = size
	button.scale = Vector2(2, 2)
	button.flip_h = true
