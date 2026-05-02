extends Control

# Referenciando a subcena do personagem na árvore de nós da Home
@onready var character_node = $Character

# ========================
# Services
# ========================
@onready var TaskService = preload("res://scripts/services/task_service.gd").new()
@onready var UserService = preload("res://scripts/services/user_service.gd").new()

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
	add_child(UserService)
	add_child(TaskService)

	UserService.load_or_create_user()

	if btn_calendar == null:
		push_error("CalendarButton não encontrado!")
		return
	if vbox_tasks == null:
		push_error("VBoxTarefas não encontrado!")
		return
	if coin_label == null:
		push_error("coin_label não encontrado!")
		return
	
	# ------- MAIN VBOX STYLE --------
	_stylize_vbox(vbox_tasks)

	# Connect calendar
	btn_calendar.pressed.connect(_on_calendar_button_pressed)

	# Update main UI
	update_coin_label()
	TaskService.update_list(vbox_tasks, self)
	
	# Update Character Skin e Tamanho
	update_character_skin()

# ===============================
# FUNCTION: Stylize container
# ===============================
func _stylize_vbox(vbox: VBoxContainer):
	vbox.custom_minimum_size = Vector2(800, 500)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 16)

# ===============================
# UPDATE COINS ON SCREEN
# ===============================
func update_coin_label():
	var coins = UserService.get_coins()
	coin_label.text = str(coins)

# ===============================
# POPUP TASKS
# ===============================
func _on_calendar_button_pressed() -> void:
	print("CLICOU no CALENDARIO!")
	var popup = AcceptDialog.new()
	click_sound.play()
	popup.title = tr("TASKS")
	popup.min_size = Vector2(420, 460)
	add_child(popup)

	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.custom_minimum_size = Vector2(400, 440)

	_stylize_vbox(vbox)
	popup.add_child(vbox)

	# ------- LABEL ----------
	var info_label = Label.new()
	info_label.text = tr("TASK_LIST")
	info_label.add_theme_font_size_override("font_size", 26)
	vbox.add_child(info_label)

	# ------- TASKS LIST ----------
	var tasks_container = VBoxContainer.new()
	_stylize_vbox(tasks_container)
	vbox.add_child(tasks_container)

	# Load current list
	TaskService.update_list(tasks_container, self)

	# ------- INPUT NEW TASK ----------
	var new_label = Label.new()
	new_label.text = "\n" + tr("TASK_LIST")
	new_label.add_theme_font_size_override("font_size", 26)
	vbox.add_child(new_label)

	var title_input = LineEdit.new()
	title_input.placeholder_text = tr("TASK_TITLE")
	title_input.add_theme_font_size_override("font_size", 22)
	title_input.custom_minimum_size = Vector2(0, 45)
	vbox.add_child(title_input)

	var desc_input = LineEdit.new()
	desc_input.placeholder_text = tr("DESCRIPTION")
	desc_input.add_theme_font_size_override("font_size", 22)
	desc_input.custom_minimum_size = Vector2(0, 45)
	vbox.add_child(desc_input)

	var btn_confirm = Button.new()
	btn_confirm.text = tr("CREATE")
	btn_confirm.custom_minimum_size = Vector2(0, 55)
	btn_confirm.add_theme_font_size_override("font_size", 24)
	btn_confirm.pressed.connect(click_sound.play)

	btn_confirm.pressed.connect(
		Callable(self, "_create_task")
		.bind(title_input, desc_input, tasks_container)
	)

	vbox.add_child(btn_confirm)
	popup.popup_centered()

func _create_task(title_input: LineEdit, desc_input: LineEdit, tasks_container: VBoxContainer):
	var title = title_input.text.strip_edges()
	var desc = desc_input.text.strip_edges()

	if title == "":
		push_error(tr("TITLE_ERROR"))
		return

	title_input.text = ""
	desc_input.text = ""

	TaskService.update_list(tasks_container, self)
	print(tr("TASK_CREATED"), title)

func on_task_complete():
	update_coin_label()
	TaskService.update_list(vbox_tasks, self)


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

	# Tenta carregar a skin salva do usuário
	if ResourceLoader.exists(skin_path):
		texture_button.texture_normal = load(skin_path)
		_aplicar_redimensionamento_button(texture_button, novo_tamanho)
		print("Skin equipada alterada com sucesso!")
		return

	# Se a skin equipada não existir, carrega a padrão fallback
	if ResourceLoader.exists(default_path):
		texture_button.texture_normal = load(default_path)
		_aplicar_redimensionamento_button(texture_button, novo_tamanho)
		print("Skin equipada não foi encontrada. Carregando a padrão: default.png")
	else:
		push_error("ERRO GRAVE: Nem a skin equipada nem a padrão (default.png) foram encontradas!")

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
