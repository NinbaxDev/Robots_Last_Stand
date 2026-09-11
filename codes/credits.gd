extends Control

func _on_back_pressed() -> void:
	$AudioStreamPlayer2D.play()
	await  get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://menu.tscn")
