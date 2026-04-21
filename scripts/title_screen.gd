extends Control

#popup
@onready var ConfigScreen = preload("res://scenes/config_screen.tscn")
@onready var Credits = preload("res://scenes/credits.tscn")

#labels
@onready var button_play_label = $VBoxContainer/PlayButton
@onready var button_exit_label = $VBoxContainer/ExitButton
@onready var click_sound = $click_sound

func _ready():
	#insert text in buttons
	button_play_label.text = "JOGAR"
	button_exit_label.text = "SAIR"

func _on_play_button_pressed() -> void:
	click_sound.play()
	#await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/home.tscn")

func _on_exit_button_pressed() -> void:
	click_sound.play()
	#await click_sound.finished
	get_tree().quit()

func _on_config_button_pressed() -> void:
	click_sound.play()
	#await click_sound.finished
	var config_screen = ConfigScreen.instantiate()
	add_child(config_screen)
	
func _on_credits_button_pressed() -> void:
	click_sound.play()
	#await click_sound.finished
	var credits = Credits.instantiate()
	add_child(credits)
	
func _on_config_exit_pressed() -> void:
	click_sound.play()
	#await click_sound.finished
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
