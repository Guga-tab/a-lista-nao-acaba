extends Control

#popup
@onready var ConfigScreen = preload("res://scenes/pop_ups/config.tscn")

#labels
@onready var button_play_label = $Bg/StartButton/Label
@onready var button_exit_label  = $Bg/BackButton/Label
@onready var click_sound = $click_sound
@onready var minutes : Label = $Bg/ClockBg/MM
@onready var seconds : Label = $Bg/ClockBg/SS

var minutes_value = 0
var seconds_value = 0
var total_time = 0.0
var running = false
var paused = false

func _ready():
	#insert text in buttons
	button_play_label.text = "START"
	button_exit_label.text = "BACK"

	minutes.text = "%02d" % minutes_value
	seconds.text = "%02d" % seconds_value
	
func _process(delta: float) -> void:
	
	if running and total_time > 0:
		total_time -= delta
		
	var m = int(total_time) / 60
	var s = int(total_time) % 60

	minutes.text = "%02d" % m
	seconds.text = "%02d" % s

	if total_time <= 0:
		running = false
		paused = false
		button_play_label.text = "START"
	
func _on_start_button_pressed() -> void:
	click_sound.play()
	#await click_sound.finished
	
	if not running and not paused:
		total_time = minutes_value * 60
		running = true
		button_play_label.text = "PAUSE"
		return

	if running:
		running = false
		paused = true
		button_play_label.text = "CONTINUE"
		return

	if paused:
		running = true
		paused = false
		button_play_label.text = "PAUSE"

func _on_config_button_pressed() -> void:
	click_sound.play()
	#await click_sound.finished
	var config_screen = ConfigScreen.instantiate()
	add_child(config_screen)
	
func _on_back_button_pressed() -> void:
	click_sound.play()
	#await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/screens/title.tscn")

func _on_up_clock_pressed() -> void:
	if(minutes_value < 120):
		minutes_value += 5
		
		if not running:
			total_time = minutes_value * 60

func _on_dn_clock_pressed() -> void:
	if(minutes_value > 0):
		minutes_value -= 5
		
		if not running:
			total_time = minutes_value * 60
