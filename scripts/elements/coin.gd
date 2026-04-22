extends TextureRect

@onready var coins_label: Label = $CoinLabel
@onready var user_service = preload("res://scripts/services/user_service.gd").new()

func _ready():
	add_child(user_service)

	# show initial value
	update_coins()

	# connect signal
	user_service.coins_changed.connect(_on_coins_changed)

func update_coins():
	coins_label.text = str(user_service.get_coins())

func _on_coins_changed(new_value:int):
	coins_label.text = str(new_value)
