extends Node

# Carrega UserService
var user_service := preload("res://UserService.gd").new()

# Referência para a cena principal (Control)
var main_scene: Node = null


func _ready():
	add_child(user_service)


# ==========================================================
#  SET principal (para atualizar coins)
# ==========================================================
func set_main(main_ref: Node):
	main_scene = main_ref


# ==========================================================
#  CRIAR TAREFA
# ==========================================================
func criar_tarefa(titulo: String, descricao: String) -> void:
	if titulo.strip_edges() == "":
		push_error("Título não pode ser vazio")
		return

	user_service.carregar_ou_criar_usuario()
	var ids = user_service.get_user_ids()

	# Cada tarefa dá 1 coin (pode mudar depois)
	var recompensa := 1

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
		titulo,
		descricao,
		ids.id_usuario,
		ids.id_avatar,
		recompensa
	])

	print("[TAREFA] Criada:", titulo)


# ==========================================================
#  CONCLUIR TAREFA
# ==========================================================
func concluir_tarefa(id_tarefa: int) -> void:
	user_service.carregar_ou_criar_usuario()

	# Recuperar recompensa
	var tarefa = Database.fetch_one("""
		SELECT coins_recompensa
		FROM TAREFA
		WHERE id_tarefa = ?
	""", [id_tarefa])

	if tarefa == null:
		push_error("Tarefa não encontrada.")
		return

	var coins = tarefa["coins_recompensa"]

	# Marcar conclusão
	Database.exec("""
		UPDATE TAREFA
		SET concluida = 1,
			pendente = 0,
			data_conclusao = strftime('%s','now')
		WHERE id_tarefa = ?
	""", [id_tarefa])

	print("[TAREFA] Concluída! +" + str(coins) + " coins")

	# Dar coins
	user_service.adicionar_coins(coins)

	# Atualizar UI principal
	if main_scene != null:
		main_scene.on_tarefa_concluida()


# ==========================================================
#  LISTAR TAREFAS NA UI
# ==========================================================
func atualizar_lista(vbox: VBoxContainer, main_ref: Node = null) -> void:
	if main_ref != null:
		main_scene = main_ref
	if vbox == null:
		push_error("VBox inválido")
		return

	user_service.carregar_ou_criar_usuario()
	var ids = user_service.get_user_ids()

	var tarefas = Database.fetch_all("""
		SELECT id_tarefa, titulo, descricao
		FROM TAREFA
		WHERE FK_USUARIO_AVATAR_id_usuario = ?
		  AND FK_USUARIO_AVATAR_id_avatar = ?
		  AND pendente = 1
		ORDER BY data_criacao DESC
	""", [
		ids.id_usuario,
		ids.id_avatar
	])

	# Limpa UI
	for child in vbox.get_children():
		child.queue_free()

	# Monta UI
	for t in tarefas:
		var linha = HBoxContainer.new()
		linha.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		linha.custom_minimum_size = Vector2(0, 50)

		# ----------- TÍTULO ----------
		var label_t = Label.new()
		label_t.text = t["titulo"]
		label_t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label_t.add_theme_font_size_override("font_size", 22)

		# ----------- DESCRIÇÃO ----------
		var label_d = Label.new()
		label_d.text = t["descricao"]
		label_d.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label_d.add_theme_font_size_override("font_size", 20)

		# ----------- BOTÃO ✔ ----------
		var btn_done = Button.new()
		btn_done.text = "✔"
		btn_done.custom_minimum_size = Vector2(50, 50)
		btn_done.add_theme_font_size_override("font_size", 30)

		btn_done.pressed.connect(
			Callable(self, "_on_concluir_tarefa")
			.bind(t["id_tarefa"], vbox)
		)

		linha.add_child(label_t)
		linha.add_child(label_d)
		linha.add_child(btn_done)

		vbox.add_child(linha)


# ==========================================================
#  HANDLER: botão ✔ clicado
# ==========================================================
func _on_concluir_tarefa(id_tarefa: int, vbox: VBoxContainer):
	concluir_tarefa(id_tarefa)
	atualizar_lista(vbox)
