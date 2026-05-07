extends TextureRect

@onready var label_count = $OffensiveLabel # Certifique-se de que este é o nome da sua Label

func _ready() -> void:
	# Garante que os dados do usuário existam [cite: 64]
	UserService.load_or_create_user()
	
	# 1. Verifica se a ofensiva expirou por ausência assim que a tela abre [cite: 83, 94]
	UserService.check_streak_expiry()
	
	# 2. Atualiza a interface visual [cite: 78, 79]
	update_ui()

func update_ui():
	var data = UserService.get_streak_data() # [cite: 78, 79]
	var count = int(data["count"])
	
	label_count.text = str(count)
	
	# Estética: Se a ofensiva for 0, o ícone fica meio transparente/apagado [cite: 84]
	if count > 0:
		self.modulate = Color(1, 1, 1, 1) # Normal
	else:
		self.modulate = Color(1, 1, 1, 0.4) # Apagado
