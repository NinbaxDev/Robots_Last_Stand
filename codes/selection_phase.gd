extends Control

@onready var easy_text = $Easy
@onready var medium_text = $Medium
@onready var hard_text = $Hard

func _on_easy_pressed() -> void:
	$AudioStreamPlayer2D.play()
	easy_text.visible = true
	RoundManager.limit_round = 10
	await get_tree().create_timer(2).timeout
	easy_text.visible = false
	get_tree().change_scene_to_file("res://wizard_stand.tscn")

func _on_medium_pressed() -> void:
	$AudioStreamPlayer2D.play()
	medium_text.visible = true
	RoundManager.limit_round = 15
	await get_tree().create_timer(2).timeout
	medium_text.visible = false
	get_tree().change_scene_to_file("res://wizard_stand.tscn")

func _on_hard_pressed() -> void:
	$AudioStreamPlayer2D.play()
	hard_text.visible = true
	RoundManager.limit_round = 25
	await get_tree().create_timer(2).timeout
	hard_text.visible = false
	get_tree().change_scene_to_file("res://wizard_stand.tscn")

func _on_back_pressed() -> void:
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://menu.tscn")
