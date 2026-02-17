extends Control

#buttons
@onready var button_play = $ButtonPlay
@onready var button_exit = $ButtonExit

#labels
@onready var button_play_label = $ButtonPlay/TextureButton/Label
@onready var button_exit_label = $ButtonExit/TextureButton/Label

func _ready():
	#insert text in buttons
	button_play_label.text = "JOGAR"
	button_exit_label.text = "SAIR"

func _on_button_play_pressed() -> void:
	print("Botão JOGAR clicado!")
	get_tree().change_scene_to_file("res://scenes/Home.tscn")

func _on_button_exit_pressed() -> void:
	print("Botão SAIR clicado!")
	get_tree().quit()
