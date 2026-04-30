extends Control

#popup
@onready var ConfigScreen = preload("res://scenes/pop_ups/config.tscn")
@onready var TaskService = preload("res://scripts/services/task_service.gd").new()
@onready var UserService = preload("res://scripts/services/user_service.gd").new()
#labels
@onready var task_input = $Bg/TaskFrame/LineEdit
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
	# SALVAR TAREFA
	if not running and not paused:
		var description = task_input.text
		var title = ""
		TaskService.create_task(
			title,
			description,
			minutes_value
		)

		total_time = minutes_value * 60
		running = true
		button_play_label.text = "PAUSE"
		
		var mission_scene = preload("res://scenes/screens/mission.tscn").instantiate()
		mission_scene.minutes_value = minutes_value
		mission_scene.seconds_value = seconds_value
		mission_scene.task_text = description

		get_tree().current_scene.call_deferred("free")
		get_tree().root.add_child(mission_scene)
		get_tree().current_scene = mission_scene
		
		return

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
		minutes_value += 1
		
		if not running:
			total_time = minutes_value * 60

func _on_dn_clock_pressed() -> void:
	if(minutes_value > 0):
		minutes_value -= 1
		
		if not running:
			total_time = minutes_value * 60
