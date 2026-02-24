extends Node

@onready var Database = preload("res://scripts/DatabaseJSON.gd").new()
@onready var user_service = preload("res://scripts/UserService.gd").new()

var main_scene: Node = null

func _ready():
	add_child(Database)
	add_child(user_service)

func set_main(main_ref: Node):
	main_scene = main_ref

func create_task(title: String, desc: String) -> void:
	if title.strip_edges() == "":
		push_error("Título não pode ser vazio")
		return

	user_service.load_or_create_user()
	var ids: Dictionary = user_service.get_user_ids()

	var reward := 1

	Database.create_task(
		title,
		desc,
		ids["user_id"],
		ids["avatar_id"],
		reward
	)

	print("[TAREFA] Criada:", title)

func complete_task(task_id: int) -> void:
	user_service.load_or_create_user()

	var task := Database.complete_task(task_id)

	if task.is_empty():
		push_error("Tarefa não encontrada")
		return

	var coins := int(task["coins_recompensa"])

	user_service.add_coins(coins)

	print("[TAREFA] Concluída! +", coins)

	if main_scene != null:
		main_scene.on_task_complete()

func update_list(vbox: VBoxContainer, main_ref: Node = null) -> void:
	if main_ref != null:
		main_scene = main_ref

	if vbox == null:
		push_error("VBox inválido")
		return

	user_service.load_or_create_user()
	var ids: Dictionary = user_service.get_user_ids()

	var tasks := Database.get_pending_tasks(
		ids["user_id"],
		ids["avatar_id"]
	)

	for child in vbox.get_children():
		child.queue_free()

	for t in tasks:
		var line := HBoxContainer.new()
		line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line.custom_minimum_size = Vector2(0, 50)

		var label_t := Label.new()
		label_t.text = str(t["titulo"])
		label_t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label_t.add_theme_font_size_override("font_size", 22)

		var label_d := Label.new()
		label_d.text = str(t["descricao"])
		label_d.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label_d.add_theme_font_size_override("font_size", 20)

		var btn_done := Button.new()
		btn_done.text = "✔"
		btn_done.custom_minimum_size = Vector2(50, 50)
		btn_done.add_theme_font_size_override("font_size", 30)

		btn_done.pressed.connect(
			Callable(self, "_on_complete_task")
			.bind(int(t["id_tarefa"]), vbox)
		)

		line.add_child(label_t)
		line.add_child(label_d)
		line.add_child(btn_done)

		vbox.add_child(line)

func _on_complete_task(task_id: int, vbox: VBoxContainer):
	complete_task(task_id)
	update_list(vbox)
