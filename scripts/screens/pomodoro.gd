extends Control

# PopUp
@onready var ConfigScreen = preload("res://scenes/pop_ups/config.tscn")
@onready var TaskService = preload("res://scripts/services/task_service.gd").new()

# Labels
@onready var task_input = $Bg/TaskFrame/TaskText
@onready var button_play_label = $Bg/StartButton/Label
@onready var button_exit_label  = $Bg/BackButton/Label
@onready var click_sound = $click_sound
@onready var minutes : Label = $Bg/ClockBg/ClockCircle1/MM
@onready var seconds : Label = $Bg/ClockBg/ClockCircle2/SS
@onready var input_task = $Bg/TaskFrame/TaskText

@onready var start_button: Button = $Bg/StartButton

var minutes_value = 0
var seconds_value = 0
var total_time = 0.0
var running = false
var paused = false

func _ready():

	button_play_label.text = "START"
	button_exit_label.text = "BACK"

	minutes.text = "%02d" % minutes_value
	seconds.text = "%02d" % seconds_value
	
	if task_input.has_signal("text_changed"):
		task_input.text_changed.connect(_on_task_text_changed)
		
	check_start_button_validity()

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
		
	check_start_button_validity()

	# Block pomodoro start
func check_start_button_validity() -> void:
	if start_button:
		var has_text = task_input.text.strip_edges() != ""
		var has_time = minutes_value > 0 or seconds_value > 0
		
		if has_text and has_time:
			start_button.disabled = false
			start_button.modulate = Color(1, 1, 1)
		else:
			start_button.disabled = true
			start_button.modulate = Color(0.5, 0.5, 0.5)

func _on_task_text_changed() -> void:
	check_start_button_validity()

func _on_start_button_pressed() -> void:
	if start_button.disabled:
		return
		
	click_sound.play()
	
	# Save Task
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
	var config_screen = ConfigScreen.instantiate()
	add_child(config_screen)
	
func _on_back_button_pressed() -> void:
	click_sound.play()
	get_tree().change_scene_to_file("res://scenes/screens/home.tscn")

func _on_up_clock_pressed() -> void:
	if minutes_value < 120:
		minutes_value += 1
		
		if not running:
			total_time = minutes_value * 60
			
	check_start_button_validity()

func _on_dn_clock_pressed() -> void:
	if minutes_value > 0:
		minutes_value -= 1
		
		if not running:
			total_time = minutes_value * 60
			
	check_start_button_validity()

func _on_line_edit_text_changed(new_text):
	check_start_button_validity()
