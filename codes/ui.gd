extends CanvasLayer

@onready var player = get_node("../Player")
@onready var round = $Round

func _ready() -> void:
	$Player_life.text = str("PLAYER LIFE:", PlayerData.life)
	player.life_update_p.connect(life_update_player)
	round.text = str(RoundManager.current_round)

func life_update_player(life: int) -> void:
	$Player_life.text = str("PLAYER LIFE:", life)

func new_round():
	round.text = str(RoundManager.current_round)

func show_options():
	await get_tree().create_timer(1).timeout
	$Coin.play()
	if PlayerData.velocity <= 320.0:
		$Mobility_button.visible = true
	if PlayerData.attack < 5:
		$Overcharge_button.visible = true
	if PlayerData.attack_speed > 0.0:
		$Rapidfire_button.visible = true
	if PlayerData.max_life <= 40:
		$Regen_button.visible = true
	if PlayerData.shield == 0:
		$Shield_button.visible = true
	if PlayerData.max_life >= 40 && PlayerData.attack_speed < 0.0 && PlayerData.attack > 5 && PlayerData.velocity >= 320.0 && PlayerData.shield > 0:
		Globalsignal.powerup_selected.emit()
	new_round()

func _on_mobility_button_pressed() -> void:
	PlayerData.velocity *= 1.1
	$AudioStreamPlayer2D.play()
	$Mobility_button.visible = false
	$Overcharge_button.visible = false
	$Rapidfire_button.visible = false
	$Regen_button.visible = false
	$Shield_button.visible = false
	await get_tree().create_timer(0.5).timeout
	Globalsignal.powerup_selected.emit()

func _on_overcharge_button_pressed() -> void:
	PlayerData.attack += 1
	$AudioStreamPlayer2D.play()
	$Mobility_button.visible = false
	$Overcharge_button.visible = false
	$Rapidfire_button.visible = false
	$Regen_button.visible = false
	$Shield_button.visible = false
	await get_tree().create_timer(0.5).timeout
	Globalsignal.powerup_selected.emit()

func _on_rapidfire_button_pressed() -> void:
	PlayerData.attack_speed -= 0.1
	$AudioStreamPlayer2D.play()
	$Mobility_button.visible = false
	$Overcharge_button.visible = false
	$Rapidfire_button.visible = false
	$Regen_button.visible = false
	$Shield_button.visible = false
	await get_tree().create_timer(0.5).timeout
	Globalsignal.powerup_selected.emit()

func _on_regen_button_pressed() -> void:
	PlayerData.max_life += 5
	PlayerData.life = PlayerData.max_life
	life_update_player(PlayerData.life)
	$AudioStreamPlayer2D.play()
	$Mobility_button.visible = false
	$Overcharge_button.visible = false
	$Rapidfire_button.visible = false
	$Regen_button.visible = false
	$Shield_button.visible = false
	await get_tree().create_timer(0.5).timeout
	Globalsignal.powerup_selected.emit()

func _on_shield_button_pressed() -> void:
	PlayerData.shield = 3
	$AudioStreamPlayer2D.play()
	$Mobility_button.visible = false
	$Overcharge_button.visible = false
	$Rapidfire_button.visible = false
	$Regen_button.visible = false
	$Shield_button.visible = false
	$"../Player/Shield".visible = true
	await get_tree().create_timer(0.5).timeout
	Globalsignal.powerup_selected.emit()
