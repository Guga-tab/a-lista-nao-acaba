extends Control

# ========================
# Serviços
# ========================
@onready var tarefa_service = preload("res://scripts/TarefaService.gd").new()
@onready var user_service   = preload("res://scripts/UserService.gd").new()

# ========================
# Nós da cena
# ========================
@onready var btn_calendar = $Bg/room/CalendarButton
@onready var vbox_tarefas = $VBoxTarefas
@onready var coin_label   = $Bg/coin/coin_label

func _ready():
	# Sobe serviços
	add_child(user_service)
	add_child(tarefa_service)

	user_service.carregar_ou_criar_usuario()

	if btn_calendar == null:
		push_error("CalendarButton não encontrado!")
		return
	if vbox_tarefas == null:
		push_error("VBoxTarefas não encontrado!")
		return
	if coin_label == null:
		push_error("coin_label não encontrado!")
		return

	# ------- ESTILO DO VBOX PRINCIPAL --------
	_estilizar_vbox(vbox_tarefas)

	# Conecta calendário
	btn_calendar.pressed.connect(Callable(self, "_on_calendar_pressed"))

	# Atualiza UI inicial
	atualizar_coin_label()
	tarefa_service.atualizar_lista(vbox_tarefas, self)


# ===============================
# FUNÇÃO: Estilizar container
# ===============================
func _estilizar_vbox(vbox: VBoxContainer):
	vbox.custom_minimum_size = Vector2(800, 500)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 16)


# ===============================
# ATUALIZA COINS NA TELA
# ===============================
func atualizar_coin_label():
	var coins = user_service.get_coins()
	coin_label.text = str(coins)


# ===============================
# POPUP DE TAREFAS
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

	_estilizar_vbox(vbox)
	popup.add_child(vbox)

	# ------- LABEL ----------
	var info_label = Label.new()
	info_label.text = "Lista de tarefas:"
	info_label.add_theme_font_size_override("font_size", 26)
	vbox.add_child(info_label)

	# ------- LISTA DE TAREFAS ----------
	var tarefas_container = VBoxContainer.new()
	_estilizar_vbox(tarefas_container)
	vbox.add_child(tarefas_container)

	# Carrega lista atual
	tarefa_service.atualizar_lista(tarefas_container, self)

	# ------- INPUT NOVA TAREFA ----------
	var nova_label = Label.new()
	nova_label.text = "\nCriar nova tarefa:"
	nova_label.add_theme_font_size_override("font_size", 26)
	vbox.add_child(nova_label)

	var titulo_input = LineEdit.new()
	titulo_input.placeholder_text = "Título da tarefa"
	titulo_input.add_theme_font_size_override("font_size", 22)
	titulo_input.custom_minimum_size = Vector2(0, 45)
	vbox.add_child(titulo_input)

	var descricao_input = LineEdit.new()
	descricao_input.placeholder_text = "Descrição"
	descricao_input.add_theme_font_size_override("font_size", 22)
	descricao_input.custom_minimum_size = Vector2(0, 45)
	vbox.add_child(descricao_input)

	var btn_confirm = Button.new()
	btn_confirm.text = "Criar"
	btn_confirm.custom_minimum_size = Vector2(0, 55)
	btn_confirm.add_theme_font_size_override("font_size", 24)

	btn_confirm.pressed.connect(
		Callable(self, "_criar_tarefa")
		.bind(titulo_input, descricao_input, tarefas_container)
	)

	vbox.add_child(btn_confirm)

	popup.popup_centered()


func _criar_tarefa(titulo_input: LineEdit, descricao_input: LineEdit, tarefas_container: VBoxContainer):
	var titulo = titulo_input.text.strip_edges()
	var descricao = descricao_input.text.strip_edges()

	if titulo == "":
		push_error("Título não pode ser vazio!")
		return

	tarefa_service.criar_tarefa(titulo, descricao)

	titulo_input.text = ""
	descricao_input.text = ""

	tarefa_service.atualizar_lista(tarefas_container, self)

	print("Tarefa criada:", titulo)


func on_tarefa_concluida():
	atualizar_coin_label()
	tarefa_service.atualizar_lista(vbox_tarefas, self)
