extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/home.tscn")


func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/store.tscn")


func _on_skin_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/inventory.tscn")
