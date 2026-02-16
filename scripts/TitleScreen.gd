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

func _on_botao_jogar_pressed():
	print("Botão JOGAR clicado!")
	get_tree().change_scene_to_file("res://scenes/principal.tscn")

func _on_botao_sair_pressed():
	print("Botão SAIR clicado!")
	get_tree().quit()
