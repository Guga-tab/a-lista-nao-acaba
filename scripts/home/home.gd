extends Control

# Referenciando a subcena do personagem na árvore de nós da Home
@onready var character_node = $Character

# ========================
# NÓS DAS DECORAÇÕES (Home)
# Certifique-se de que estes caminhos existem na sua cena Home!
# ========================
@onready var deco_bedroom = $Bg/Room/Bedroom
@onready var deco_living_room = $Bg/Room/LivingRoom
@onready var deco_toilet = $Bg/Room/Toilet
@onready var deco_kitchen = $Bg/Room/Kitchen

# ========================
# Nodes of scene
# ========================
@onready var ConfigScreen = preload("res://scenes/pop_ups/config.tscn")
@onready var coin_label = $Bg/Coin/CoinLabel
@onready var text_black_bar = $Bg/TextBlackBar
@onready var click_sound = $click_sound

func _ready():
	# Up services
	UserService.load_or_create_user()
	
	# CONEXÃO: Sempre que o UserService avisar que a skin mudou, roda a função abaixo
	if not UserService.skin_changed.is_connected(_on_skin_changed):
		UserService.skin_changed.connect(_on_skin_changed)
	
	# Carregamento Inicial (Skins e Decorações) 
	update_character_skin()
	apply_equipped_decorations() # Chamada inicial para mostrar os cômodos comprados
	
	# Update main UI
	update_coin_label()

# Função chamada automaticamente quando o sinal 'skin_changed' é emitido
func _on_skin_changed(_new_skin_name: String):
	update_character_skin()

# ===============================
# UPDATE COINS ON SCREEN
# ===============================
func update_coin_label():
	var coins = UserService.get_coins()
	coin_label.text = str(coins)

func _on_config_button_pressed() -> void:
	click_sound.play()
	var config_screen = ConfigScreen.instantiate()
	add_child(config_screen)

# ===============================
# UPDATE CHARACTER SKIN & SIZE
# ===============================
func update_character_skin() -> void:
	var equipped_skin = UserService.get_equipped_skin()
	print("Sua skin salva no banco é: ", equipped_skin)

	var skin_path = "res://assets/characters/skins/" + equipped_skin + ".png"
	var default_path = "res://assets/characters/skins/default.png"
	var novo_tamanho = Vector2(150, 250)

	var texture_button = character_node.get_node("TextureButton") as TextureButton

	if texture_button == null:
		push_error("ERRO GRAVE: O TextureButton não foi encontrado dentro do nó Character!")
		return

	texture_button.texture_normal = null
	
	if ResourceLoader.exists(skin_path):
		texture_button.texture_normal = load(skin_path)
		_aplicar_redimensionamento_button(texture_button, novo_tamanho)
		print("Skin equipada alterada com sucesso!")
	elif ResourceLoader.exists(default_path):
		texture_button.texture_normal = load(default_path)
		_aplicar_redimensionamento_button(texture_button, novo_tamanho)
		print("Skin equipada não foi encontrada. Carregando a padrão: default.png")
	else:
		push_error("ERRO GRAVE: Nem a skin equipada nem a padrão encontradas!")

# ====================================================
# FUNÇÃO PARA EXIBIR/OCULTAR AS DECORAÇÕES (Idêntica à Missão) [cite: 166]
# ====================================================
func apply_equipped_decorations() -> void:
	var equipped_decorations = UserService.get_equipped_decorations()

	# Esconde todas por padrão antes de checar as equipadas [cite: 166]
	if deco_bedroom: deco_bedroom.visible = false
	if deco_living_room: deco_living_room.visible = false
	if deco_toilet: deco_toilet.visible = false
	if deco_kitchen: deco_kitchen.visible = false

	# Torna visíveis apenas as que estiverem no Array de equipadas 
	if "bedroom" in equipped_decorations and deco_bedroom:
		deco_bedroom.visible = true
	if "living_room" in equipped_decorations and deco_living_room:
		deco_living_room.visible = true
	if "toilet" in equipped_decorations and deco_toilet:
		deco_toilet.visible = true
	if "kitchen" in equipped_decorations and deco_kitchen:
		deco_kitchen.visible = true

func _aplicar_redimensionamento_button(button: TextureButton, size: Vector2) -> void:
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.custom_minimum_size = size
	button.size = size
	button.scale = Vector2(2, 2)
	button.flip_h = true
