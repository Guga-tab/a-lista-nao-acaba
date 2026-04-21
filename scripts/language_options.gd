extends OptionButton

func _ready() -> void:
	add_item("Português", 0)
	add_item("English", 1)
	#add_item("Español", 2)
	#add_item("Français", 3)
	#add_item("Deutsch", 4)
	#add_item("Italiano", 5)
	#add_item("Русский", 6)
	#add_item("日本語", 7)
	#add_item("简体中文", 8)
	#add_item("繁體中文", 9)

func _on_item_selected(index: int) -> void:
	var id = get_item_id(index)

	match id:
		0:
			TranslationServer.set_locale("pt")
		1:
			TranslationServer.set_locale("en_US")
		2:
			TranslationServer.set_locale("es")
		3: 
			TranslationServer.set_locale("fr")
		4: 
			TranslationServer.set_locale("de")
		5: 
			TranslationServer.set_locale("it")
		6: 
			TranslationServer.set_locale("ru")
		7: 
			TranslationServer.set_locale("ja")
		8: 
			TranslationServer.set_locale("zh_cn")
		9: 
			TranslationServer.set_locale("zh_tw") 
