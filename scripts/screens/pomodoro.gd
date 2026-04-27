extends Control

#popup
@onready var ConfigScreen = preload("res://scenes/pop_ups/config.tscn")

#labels
@onready var button_play_label = $Bg/StartButton
@onready var button_exit_label = $Bg/BackButton
@onready var click_sound = $click_sound

func _ready():
	#insert text in buttons
	button_play_label.text = "START"
	button_exit_label.text = "BACK"

func _on_start_button_pressed() -> void:
	click_sound.play()
	#await click_sound.finished

func _on_config_button_pressed() -> void:
	click_sound.play()
	#await click_sound.finished
	var config_screen = ConfigScreen.instantiate()
	add_child(config_screen)
	
func _on_back_button_pressed() -> void:
	click_sound.play()
	#await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/screens/title.tscn")
