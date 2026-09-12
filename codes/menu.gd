extends Control

func _ready() -> void:
	MusicPlayer.play_music_level()

func _on_start_pressed() -> void:
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://wizard_stand.tscn")

func _on_credits_pressed() -> void:
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://credits.tscn")

func _on_exit_pressed() -> void:
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
