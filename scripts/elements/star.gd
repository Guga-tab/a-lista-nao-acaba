extends TextureRect

@onready var stars_label = $StarLabel # Certifique-se de que este é o nome da sua Label

func _ready() -> void:
	# Inicializa os dados [cite: 64]
	UserService.load_or_create_user()
	update_stars_ui()

func update_stars_ui():
	# Busca o saldo real do UserService [cite: 86, 104]
	var stars = UserService.get_stars_balance()
	
	stars_label.text = str(int(stars))
	
	# Se não tiver estrelas, o ícone pode ficar levemente diferente
	if stars > 0:
		self.modulate = Color(1, 1, 1, 1)
	else:
		self.modulate = Color(0.8, 0.8, 0.8, 0.8) # Um pouco mais escuro se estiver zerado
