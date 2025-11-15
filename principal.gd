extends Control

# ========================
# Serviço de tarefas
# ========================
@onready var tarefa_service = preload("res://TarefaService.gd").new()

# ========================
# Nós da cena
# ========================
@onready var btn_calendar = $background/TextureRect/CalendarButton
@onready var vbox_tarefas = $VBoxTarefas  # Este deve ser um VBoxContainer na cena principal

func _ready():
	if btn_calendar == null:
		push_error("CalendarButton não encontrado! Verifique o path")
		return
	if vbox_tarefas == null:
		push_error("VBoxTarefas não encontrado! Verifique o path")
		return
	if typeof(vbox_tarefas) != TYPE_OBJECT or not vbox_tarefas is VBoxContainer:
		push_error("VBoxTarefas encontrado, mas não é VBoxContainer! Tipo: %s" % typeof(vbox_tarefas))
		return

	# Conecta sinal do botão Calendar
	var cb = Callable(self, "_on_calendar_pressed")
	if not btn_calendar.pressed.is_connected(cb):
		btn_calendar.pressed.connect(cb)

	# Atualiza lista de tarefas ao iniciar
	tarefa_service.atualizar_lista(vbox_tarefas)


# -----------------------------
# Popup para criar nova tarefa + listar
# -----------------------------
func _on_calendar_pressed():
	print("Botão Calendar clicou!")

	var popup = AcceptDialog.new()
	popup.title = "Tarefas"              # ✅ Godot 4.5
	popup.min_size = Vector2(400, 400)   # Define o tamanho mínimo do popup
	add_child(popup)

	# VBoxContainer principal dentro do popup
	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.custom_minimum_size = Vector2(380, 380)  # para dar mais espaço
	popup.add_child(vbox)

	# Label explicativa
	var info_label = Label.new()
	info_label.text = "Lista de tarefas existentes:"
	vbox.add_child(info_label)

	# Container para as tarefas já existentes
	var tarefas_container = VBoxContainer.new()
	tarefas_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tarefas_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(tarefas_container)

	# Preenche com as tarefas existentes
	tarefa_service.atualizar_lista(tarefas_container)

	# Espaço para adicionar nova tarefa
	var nova_label = Label.new()
	nova_label.text = "\nAdicionar nova tarefa:"
	vbox.add_child(nova_label)

	var titulo_input = LineEdit.new()
	titulo_input.placeholder_text = "Digite o título"
	vbox.add_child(titulo_input)

	var descricao_input = LineEdit.new()
	descricao_input.placeholder_text = "Digite a descrição"
	vbox.add_child(descricao_input)

	# Botão Criar
	var btn_confirm = Button.new()
	btn_confirm.text = "Criar"
	btn_confirm.pressed.connect(Callable(self, "_criar_tarefa").bind(titulo_input, descricao_input, tarefas_container))
	vbox.add_child(btn_confirm)

	popup.popup_centered()


# -----------------------------
# Função que cria a tarefa e atualiza a lista no popup
# -----------------------------
func _criar_tarefa(titulo_input: LineEdit, descricao_input: LineEdit, tarefas_container: VBoxContainer):
	var titulo = titulo_input.text.strip_edges()
	var descricao = descricao_input.text.strip_edges()

	if titulo == "":
		push_error("Título da tarefa não pode ser vazio!")
		return

	# Cria tarefa no serviço
	tarefa_service.criar_tarefa(titulo, descricao)

	# Limpa inputs
	titulo_input.text = ""
	descricao_input.text = ""

	# Atualiza lista de tarefas
	tarefa_service.atualizar_lista(tarefas_container)

	print("Tarefa criada:", titulo)
