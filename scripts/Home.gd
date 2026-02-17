extends Control

# ========================
# Services
# ========================
@onready var task_service = preload("res://scripts/TaskService.gd").new()
@onready var user_service   = preload("res://scripts/UserService.gd").new()

# ========================
# Nodes of scene
# ========================
@onready var btn_calendar = $Bg/room/CalendarButton
@onready var vbox_tasks = $VBoxTasks
@onready var coin_label   = $Bg/coin/coin_label

func _ready():
	# Up services
	add_child(user_service)
	add_child(task_service)

	user_service.load_or_create_user()

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
	btn_calendar.pressed.connect(_on_calendar_pressed)

	# Update main UI
	update_coin_label()
	task_service.update_list(vbox_tasks, self)

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
	var coins = user_service.get_coins()
	coin_label.text = str(coins)

# ===============================
# POPUP TASKS
# ===============================
func _on_calendar_pressed():
	var popup = AcceptDialog.new()
	popup.title = "Tarefas"
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
	info_label.text = "Lista de tarefas:"
	info_label.add_theme_font_size_override("font_size", 26)
	vbox.add_child(info_label)

	# ------- TASKS LIST ----------
	var tasks_container = VBoxContainer.new()
	_stylize_vbox(tasks_container)
	vbox.add_child(tasks_container)

	# Load current list
	task_service.update_list(tasks_container, self)

	# ------- INPUT NEW TASK ----------
	var new_label = Label.new()
	new_label.text = "\nCriar nova tarefa:"
	new_label.add_theme_font_size_override("font_size", 26)
	vbox.add_child(new_label)

	var title_input = LineEdit.new()
	title_input.placeholder_text = "Título da tarefa"
	title_input.add_theme_font_size_override("font_size", 22)
	title_input.custom_minimum_size = Vector2(0, 45)
	vbox.add_child(title_input)

	var desc_input = LineEdit.new()
	desc_input.placeholder_text = "Descrição"
	desc_input.add_theme_font_size_override("font_size", 22)
	desc_input.custom_minimum_size = Vector2(0, 45)
	vbox.add_child(desc_input)

	var btn_confirm = Button.new()
	btn_confirm.text = "Criar"
	btn_confirm.custom_minimum_size = Vector2(0, 55)
	btn_confirm.add_theme_font_size_override("font_size", 24)

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
		push_error("Título não pode ser vazio!")
		return

	task_service.create_task(title, desc)

	title_input.text = ""
	desc_input.text = ""

	task_service.update_list(tasks_container, self)

	print("Tarefa criada:", title)

func on_task_complete():
	update_coin_label()
	task_service.update_list(vbox_tasks, self)
