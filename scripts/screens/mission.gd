extends Control

@onready var UserService = preload("res://scripts/services/user_service.gd")
# Labels do relógio
@onready var minutes_label: Label = $TextureRect/ClockBg/ClockCircle1/MM
@onready var seconds_label: Label = $TextureRect/ClockBg/ClockCircle2/SS
@onready var task_label: Label = $TextureRect/Label
@onready var coin_label: Label = $Coin/CoinLabel
var task_text: String
# Valores recebidos
var minutes_value: int = 0
var seconds_value: int = 0
var total_time: float = 0.0
var finished = false


func _ready() -> void:
	total_time = minutes_value * 60 + seconds_value
	
	show_time(minutes_value, seconds_value)
	
	task_label.text = task_text
	
func _process(delta):
	if total_time > 0:
		total_time -= delta
		
		var m = int(total_time) / 60
		var s = int(total_time) % 60
		
		show_time(m, s)
	elif not finished:
		finished = true
		on_task_complete()

func show_time(mins:int, secs:int) -> void:
	minutes_label.text = "%02d" % mins
	seconds_label.text = "%02d" % secs

func update_coin_label():
	var coins = user_service.get_coins()
	coin_label.text = str(coins)
	
func on_task_complete():
	user_service.add_coins(1)
	update_coin_label()
	
	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_file("res://scenes/screens/home.tscn")
