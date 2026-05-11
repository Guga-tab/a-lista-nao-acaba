extends TextureRect

@onready var coins_label: Label = $CoinLabel

func _ready():
	# show initial value
	update_coins()

	# connect signal
	UserService.coins_changed.connect(_on_coins_changed)

func update_coins():
	coins_label.text = str(UserService.get_coins())

func _on_coins_changed(new_value:int):
	coins_label.text = str(new_value)
