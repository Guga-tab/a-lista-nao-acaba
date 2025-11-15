extends Node

# =====================================
# Serviço para gerenciar tarefas
# =====================================

var tarefas := []  # Lista de tarefas (cada uma é um dicionário com "titulo" e "descricao")

# Cria uma nova tarefa
func criar_tarefa(titulo: String, descricao: String) -> void:
	if titulo.strip_edges() == "":
		push_error("Título da tarefa não pode ser vazio")
		return

	var tarefa = {
		"titulo": titulo,
		"descricao": descricao
	}
	tarefas.append(tarefa)

# Atualiza a lista de tarefas na UI
func atualizar_lista(vbox: VBoxContainer) -> void:
	if vbox == null:
		push_error("VBoxContainer inválido")
		return

	# Limpa filhos existentes
	for child in vbox.get_children():
		child.queue_free()

	# Adiciona tarefas da lista
	for tarefa in tarefas:
		var hbox = HBoxContainer.new()
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.size_flags_vertical = Control.SIZE_FILL

		var titulo_label = Label.new()
		titulo_label.text = tarefa["titulo"]
		titulo_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(titulo_label)

		var descricao_label = Label.new()
		descricao_label.text = tarefa["descricao"]
		descricao_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_child(descricao_label)

		vbox.add_child(hbox)
