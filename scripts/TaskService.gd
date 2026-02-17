extends Node

var user_service := preload("res://scripts/UserService.gd").new()
var main_scene: Node = null

func _ready():
	add_child(user_service)

func set_main(main_ref: Node):
	main_scene = main_ref

func create_task(title: String, desc: String) -> void:
	if title.strip_edges() == "":
		push_error("Título não pode ser vazio")
		return

	user_service.load_or_create_user()
	var ids = user_service.get_user_ids()

	var reward := 1

	Database.exec("""
		INSERT INTO TAREFA (
			titulo,
			descricao,
			data_criacao,
			FK_USUARIO_AVATAR_id_usuario,
			FK_USUARIO_AVATAR_id_avatar,
			pendente,
			concluida,
			coins_recompensa
		)
		VALUES (?, ?, strftime('%s','now'), ?, ?, 1, 0, ?)
	""", [
		title,
		desc,
		ids.user_id,
		ids.avatar_id,
		reward
	])

	print("[TAREFA] Criada:", title)

func complete_task(task_id: int) -> void:
	user_service.load_or_create_user()

	# Get reward
	var task = Database.fetch_one("""
		SELECT coins_recompensa
		FROM TAREFA
		WHERE id_tarefa = ?
	""", [task_id])

	if task == null:
		push_error("Tarefa não encontrada.")
		return

	var coins = task["coins_recompensa"]

	# Make complete
	Database.exec("""
		UPDATE TAREFA
		SET concluida = 1,
			pendente = 0,
			data_conclusao = strftime('%s','now')
		WHERE id_tarefa = ?
	""", [task_id])

	print("[TAREFA] Concluída! +" + str(coins) + " coins")

	# Give coins
	user_service.add_coins(coins)

	# Update main UI
	if main_scene != null:
		#There's a mistake here, but IDK.
		main_scene.on_task_complete()

func update_list(vbox: VBoxContainer, main_ref: Node = null) -> void:
	if main_ref != null:
		main_scene = main_ref
	if vbox == null:
		push_error("VBox inválido")
		return

	user_service.load_or_create_user()
	var ids = user_service.get_user_ids()

	var tasks = Database.fetch_all("""
		SELECT id_tarefa, titulo, descricao
		FROM TAREFA
		WHERE FK_USUARIO_AVATAR_id_usuario = ?
		  AND FK_USUARIO_AVATAR_id_avatar = ?
		  AND pendente = 1
		ORDER BY data_criacao DESC
	""", [
		ids.user_id,
		ids.avatar_id
	])
	
	for child in vbox.get_children():
		child.queue_free()

	# Make UI
	for t in tasks:
		var line = HBoxContainer.new()
		line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line.custom_minimum_size = Vector2(0, 50)

		var label_t = Label.new()
		label_t.text = t["titulo"]
		label_t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label_t.add_theme_font_size_override("font_size", 22)

		var label_d = Label.new()
		label_d.text = t["descricao"]
		label_d.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label_d.add_theme_font_size_override("font_size", 20)

		# ----------- Button ✔ ----------
		var btn_done = Button.new()
		btn_done.text = "✔"
		btn_done.custom_minimum_size = Vector2(50, 50)
		btn_done.add_theme_font_size_override("font_size", 30)

		btn_done.pressed.connect(
			Callable(self, "_on_complete_task")
			.bind(t["id_tarefa"], vbox)
		)

		line.add_child(label_t)
		line.add_child(label_d)
		line.add_child(btn_done)

		vbox.add_child(line)

func _on_complete_task(task_id: int, vbox: VBoxContainer):
	complete_task(task_id)
	update_list(vbox)
