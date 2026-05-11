extends Node

@onready var clock_day : Label = $VBoxContainer/Day
@onready var clock_time : Label = $VBoxContainer/Time

func _process(delta: float) -> void:
	var time = Time.get_datetime_dict_from_system()
	clock_day.text = str(time.day, "/", time.month, "/", time.year)
	clock_time.text = str(time.hour, ":", time.minute, ":", time.second)
