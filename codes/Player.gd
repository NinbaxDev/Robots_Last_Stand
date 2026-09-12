extends CharacterBody2D

const JUMP_VELOCITY = -400.0
var stop = true
signal life_update_p
signal player_die

func _ready() -> void:
	$Shield.visible = false
	PlayerData.life = 500
	PlayerData.max_life = 500
	PlayerData.attack = 10
	PlayerData.attack_speed = 0.1
	PlayerData.velocity = 600
	PlayerData.shield = 1000
	PlayerData.Pause_menu = get_parent().get_node("Pause_menu")

func _physics_process(delta: float) -> void:
	if stop:
		if not is_on_floor():
			velocity += get_gravity() * delta
		if Input.is_action_just_pressed("move_jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * PlayerData.velocity
		else:
			velocity.x = move_toward(velocity.x, 0, PlayerData.velocity)
		move_and_slide()

func take_damage(damage: int) -> void:
	$AudioStreamPlayer2D.play()
	if PlayerData.shield > 0:
		PlayerData.shield -= 1
		if PlayerData.shield == 0:
			$Shield.visible = false
		return
	PlayerData.life -= damage
	life_update_p.emit(PlayerData.life)
	#print("Player life:", PlayerData.life)
	if PlayerData.life < 1:
		player_die.emit(true)
		queue_free()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("Enemy"):
		take_damage(1)

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel") and PlayerData.Pause_menu:
		if PlayerData.Pause_menu.visible:
			PlayerData.Pause_menu.hide_menu()
		else:
			PlayerData.Pause_menu.show_menu()
