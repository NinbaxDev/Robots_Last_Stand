extends Node2D

const bullet = preload("res://Player/bullet.tscn")
@onready var origin: Marker2D = $Marker2D
@onready var umbrella_sprite = $AnimatedSprite2D
var shoot = MOUSE_BUTTON_LEFT
@onready var fire_time = $Timer
var can_shoot: bool = true

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0 , 360)
	if rotation_degrees > 90 and rotation_degrees <270:
		scale.y = -1
	else:
		scale.y = 1
	if Input.is_action_just_pressed("Shoot") and can_shoot:
		var bullet_instance = bullet.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = origin.global_position
		bullet_instance.global_rotation = global_rotation
		can_shoot = false
		$AudioStreamPlayer2D.play()
		if umbrella_sprite.animation == "Close":
			umbrella_sprite.play("Open")
			await get_tree().create_timer(0.2).timeout
			umbrella_sprite.play("Close")
		await get_tree().create_timer(PlayerData.attack_speed).timeout
		can_shoot = true
		
