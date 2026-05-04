extends Control

# Importa o serviço do usuário
@onready var UserService = preload("res://scripts/services/user_service.gd").new()

# Labels do relógio e interface
@onready var minutes_label: Label = $Bg/ClockBg/ClockCircle1/MM
@onready var seconds_label: Label = $Bg/ClockBg/ClockCircle2/SS
@onready var task_label: Label = $Bg/TaskFrame/TaskText
@onready var coin_label: Label = $Coin/CoinLabel

# ====================================================
# NÓS DAS DECORAÇÕES NA CENA DA MISSÃO
# Certifique-se de que os caminhos abaixo estão corretos!
# ====================================================
@onready var deco_bedroom = $Bg/Room/Bedroom
@onready var deco_living_room = $Bg/Room/LivingRoom
@onready var deco_toilet = $Bg/Room/Toilet
@onready var deco_kitchen = $Bg/Room/Kitchen

var task_text: String
# Valores recebidos
var minutes_value: int = 0
var seconds_value: int = 0
var total_time: float = 0.0
var finished = false

func _ready() -> void:
	# Inicializa o serviço do usuário
	add_child(UserService)
	UserService.load_or_create_user()

	total_time = minutes_value * 60 + seconds_value
	
	show_time(minutes_value, seconds_value)
	
	task_label.text = task_text
	
	# Atualiza o contador de moedas inicial
	update_coin_label()
	
	# Aplica visualmente as decorações equipadas
	apply_equipped_decorations()


func _process(delta: float) -> void:
	if total_time > 0:
		total_time -= delta
		
		var m = int(total_time) / 60
		var s = int(total_time) % 60
		
		show_time(m, s)
	elif not finished:
		finished = true
		on_task_complete()

func show_time(mins: int, secs: int) -> void:
	minutes_label.text = "%02d" % mins
	seconds_label.text = "%02d" % secs


func update_coin_label() -> void:
	var coins = UserService.get_coins()
	coin_label.text = str(coins)

# ====================================================
# FUNÇÃO PARA EXIBIR/OCULTAR AS DECORAÇÕES
# ====================================================
func apply_equipped_decorations() -> void:
	var equipped_decorations = UserService.get_equipped_decorations()

	# Esconde todas por padrão
	if deco_bedroom: deco_bedroom.visible = false
	if deco_living_room: deco_living_room.visible = false
	if deco_toilet: deco_toilet.visible = false
	if deco_kitchen: deco_kitchen.visible = false

	# Torna visível todas as decorações que estiverem equipadas no Array
	if "bedroom" in equipped_decorations and deco_bedroom:
		deco_bedroom.visible = true
	if "living_room" in equipped_decorations and deco_living_room:
		deco_living_room.visible = true
	if "toilet" in equipped_decorations and deco_toilet:
		deco_toilet.visible = true
	if "kitchen" in equipped_decorations and deco_kitchen:
		deco_kitchen.visible = true

func on_task_complete() -> void:
	UserService.add_coins(10)
	update_coin_label()
	
	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_file("res://scenes/screens/home.tscn")
