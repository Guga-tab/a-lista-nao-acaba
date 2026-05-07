extends Control

# Referenciando a subcena do personagem na árvore de nós da Home
@onready var character_node = $Character

# ========================
# Nodes of scene
# ========================
@onready var ConfigScreen = preload("res://scenes/pop_ups/config.tscn")
@onready var Credits = preload("res://scenes/pop_ups/credits.tscn")
@onready var btn_calendar = $Bg/Room/CalendarButton
@onready var vbox_tasks = $VBoxTasks
@onready var coin_label = $Bg/Coin/CoinLabel
@onready var text_black_bar = $Bg/TextBlackBar
@onready var click_sound = $click_sound

func _ready():
	# Up services
	add_child(TaskService)
	UserService.load_or_create_user()
	
	# CONEXÃO: Sempre que o UserService avisar que a skin mudou, roda a função abaixo
	if not UserService.skin_changed.is_connected(_on_skin_changed):
		UserService.skin_changed.connect(_on_skin_changed)
	
	update_character_skin()
	
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

	# Tamanho desejado para o personagem na Home (pode ajustar à vontade)
	var novo_tamanho = Vector2(150, 250)

	# Buscamos o nó TextureButton dentro da subcena instanciada Character
	var texture_button = character_node.get_node("TextureButton") as TextureButton

	if texture_button == null:
		push_error("ERRO GRAVE: O TextureButton não foi encontrado dentro do nó Character!")
		return

	# Limpa a textura antiga para evitar "fantasmas" visuais antes de carregar a nova
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
		push_error("ERRO GRAVE: Nem a skin equipada nem a padrão (default.png) foram encontradas!")
		# Tenta carregar a skin salva do usuário

# Função auxiliar para redimensionar o TextureButton mantendo a proporção
func _aplicar_redimensionamento_button(button: TextureButton, size: Vector2) -> void:
	# 1. Permite que a textura ignore o tamanho original e estique
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED

	# 2. Define o tamanho em pixels da caixa do botão
	button.custom_minimum_size = size
	button.size = size

	# 3. FORÇA A ESCALA (Multiplicador visual)
	# Se 300x300 ainda estiver pequeno, aumentamos a escala do nó em si para 2x ou 3x
	button.scale = Vector2(2, 2) # Teste mudar para Vector2(3.0, 3.0) se quiser ainda maior!
	button.flip_h = true
