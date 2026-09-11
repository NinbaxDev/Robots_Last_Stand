extends CanvasLayer

@onready var player = $"../Player"

func _ready() -> void:
	visible = false

func show_menu():
	visible = true
	get_tree().paused = true
	player.stop = false

func hide_menu():
	visible = false
	get_tree().paused = false
	player.stop = true

func _on_menu_button_pressed() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://menu.tscn")

func _on_exit_button_pressed() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().quit()

func _on_back_button_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	hide_menu()
