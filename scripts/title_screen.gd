extends Control

#popup
@onready var PopUp = preload("res://scenes/pop_up.tscn")

#labels
@onready var button_play_label = $VBoxContainer/PlayButton/TextureButton/Label
@onready var button_exit_label = $VBoxContainer/ExitButton/TextureButton/Label
@onready var click_sound = $click_sound
func _ready():
	#insert text in buttons
	button_play_label.text = "JOGAR"
	button_exit_label.text = "SAIR"

func _on_play_button_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	print("Botão JOGAR clicado!")
	get_tree().change_scene_to_file("res://scenes/home.tscn")

func _on_exit_button_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	print("Botão SAIR clicado!")
	get_tree().quit()


func _on_config_button_pressed() -> void:
	click_sound.play()
	await click_sound.finish()
	var pop_up = PopUp.instantiate()
	add_child(pop_up)
