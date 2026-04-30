extends Node

var main_scene: Node = null

func _ready():
	add_child(Database)
	add_child(user_service)

func set_main(main_ref: Node):
	main_scene = main_ref

func create_task(title: String, desc: String, time: float) -> void:
	if desc.strip_edges() == "":
		push_error("Descrição não pode ser vazio") 
		return

	var ids = user_service.get_user_ids()
	var tasks = Database.get_tasks()

	var new_task = {
		"id_tarefa": Database.get_next_task_id(),
		"data_criacao": Time.get_unix_time_from_system(),
		"titulo": title,
		"descricao": desc,
		"pendente": 1,
		"concluida": 0,
		"data_conclusao": null,
		"coins_recompensa": 1,
		"FK_USUARIO_AVATAR_id_usuario": ids["user_id"],
		"FK_USUARIO_AVATAR_id_avatar": ids["avatar_id"]
	}

	tasks.append(new_task)
	Database.save_tasks(tasks)

func complete_task(task_id: int) -> void:
	var tasks = Database.get_tasks()

	for t in tasks:
		if int(t["id_tarefa"]) == task_id:
			t["concluida"] = 1
			t["pendente"] = 0
			t["data_conclusao"] = Time.get_unix_time_from_system()

			var coins = int(t["coins_recompensa"])
			user_service.add_coins(coins)
			break

	Database.save_tasks(tasks)

	if main_scene != null:
		main_scene.on_task_complete()

func update_list(vbox: VBoxContainer, main_ref: Node = null) -> void:
	if main_ref != null:
		main_scene = main_ref

	var ids = user_service.get_user_ids()
	var tasks = Database.get_tasks()

	for child in vbox.get_children():
		child.queue_free()

	for t in tasks:
		if t["FK_USUARIO_AVATAR_id_usuario"] != ids["user_id"]:
			continue
		if t["pendente"] != 1:
			continue

		var line = HBoxContainer.new()
		line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line.custom_minimum_size = Vector2(0, 50)

		var label_t = Label.new()
		label_t.text = str(t["titulo"])
		label_t.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var btn_done = Button.new()
		btn_done.text = "✔"
		btn_done.custom_minimum_size = Vector2(50, 50)

		btn_done.pressed.connect(
			Callable(self, "_on_complete_task")
			.bind(int(t["id_tarefa"]), vbox)
		)

		line.add_child(label_t)
		line.add_child(btn_done)

		vbox.add_child(line)

func _on_complete_task(task_id: int, vbox: VBoxContainer):
	complete_task(task_id)
	update_list(vbox)
