extends Control
# Adicione este @onready no topo do script para referenciar o Sprite2D do personagem
@onready var character_node = $Character# Ajuste o caminho correto do nó

func _ready() -> void:
	# CRUCIAL: Adicionar o serviço na cena para ele funcionar
	UserService.load_or_create_user()
	
	# Só então atualizamos o visual
	update_character_skin()

func update_character_skin() -> void:
	var equipped_skin = UserService.get_equipped_skin()
	print("Sua skin salva no banco é: ", equipped_skin)

	var skin_path = "res://assets/characters/skins/" + equipped_skin + ".png"
	var default_path = "res://assets/characters/skins/default.png"

	# Tamanho base da caixa do botão (mantendo a proporção)
	var novo_tamanho = Vector2(250, 300)

	# Buscamos o nó interno TextureButton da subcena CharacterRight
	var texture_react = character_node

	if texture_react == null:
		push_error("ERRO GRAVE: O TextureReact não foi encontrado dentro do nó CharacterRight!")
		return

	# 1. Tenta carregar a skin que está equipada
	if ResourceLoader.exists(skin_path):
		texture_react.texture = load(skin_path)
		_aplicar_redimensionamento_button(texture_react, novo_tamanho)
		print("Skin equipada alterada com sucesso!")
		return # Sai da função já que deu tudo certo

	# 2. Se a skin equipada não existir, tenta carregar a skin padrão
	if ResourceLoader.exists(default_path):
		texture_react.texture = load(default_path)
		_aplicar_redimensionamento_button(texture_react, novo_tamanho)
		print("Skin equipada não foi encontrada. Carregando a padrão: default.png")
	else:
		push_error("ERRO GRAVE: Nem a skin equipada nem a padrão (default.png) foram encontradas!")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/home.tscn")

func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/store.tscn")

func _on_skin_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/inventory.tscn")

# Função auxiliar idêntica à da Home para forçar a escala do personagem
func _aplicar_redimensionamento_button(texture, size: Vector2) -> void:
	texture.ignore_texture_size = true
	texture.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	texture.custom_minimum_size = size
	texture.size = size

	# FORÇA A ESCALA visual (Multiplicador de tamanho)
	# Como a tela do User dá mais destaque ao personagem, aumentamos a escala
	texture.scale = Vector2(2.5, 2.5) # Altere este valor caso queira ainda maior ou menor
