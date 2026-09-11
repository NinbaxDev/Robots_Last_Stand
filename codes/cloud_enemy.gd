extends Node2D

signal cloud_die
@export var SPEED := 200.0
@export var left_limit := 50.0
@export var right_limit := 1100.0
@export var vertical_limit := 100.0
@export var drop_scene: PackedScene
@export var shoot_interval := 1.5
@export var pattern_type := 0  # 0: linha, 1: aleatório, 2: onda
@onready var player = null
@onready var timer = $Timer
@onready var sprite = $AnimatedSprite2D
var life
var change = 0
var wave_offset := 0.0
var direction := 1
var is_dead = false

func _ready():
	life = EnemyData.life
	sprite.play("Default")
	timer.wait_time = shoot_interval
	timer.start()
	player = get_tree().get_root().get_node("Main/Player")

func _process(delta):
	if not player:
		return
	var direction_to_player = (player.global_position - global_position).normalized()
	# Movimento lateral + movimento vertical limitado
	var new_position = global_position + direction_to_player * SPEED * delta
	if new_position.y > vertical_limit:
		new_position.y = vertical_limit
	global_position = new_position

func _on_timer_timeout() -> void:
	match pattern_type:
		0:
			shoot_line()
		1:
			shoot_random()
		2:
			shoot_wave()

func shoot_line():
	for i in range(5):
		var drop = drop_scene.instantiate()
		var offset = Vector2(i * 32 - 64, 0)
		drop.global_position = global_position + offset
		get_parent().add_child(drop)
	change += 1
	if change >= 5:
		pattern_type += 1
		change = 0

func shoot_random():
	for i in range(6):
		var drop = drop_scene.instantiate()
		var random_x = randf_range(-100, 100)
		drop.global_position = global_position + Vector2(random_x, 0)
		get_parent().add_child(drop)
	change += 1
	if change >= 5:
		pattern_type += 1
		change = 0

func shoot_wave():
	for i in range(5):
		var drop = drop_scene.instantiate()
		var offset = Vector2(i * 32 - 64, sin(wave_offset + i) * 20)
		drop.global_position = global_position + offset
		get_parent().add_child(drop)
	wave_offset += 0.5
	change += 1
	if change >= 5:
		pattern_type = 0
		change = 0

func take_damage(damage: int):
	if is_dead:
		return
	$AudioStreamPlayer2D.play()
	life -= damage
	sprite.play("Hit")
	await get_tree().create_timer(0.3).timeout
	sprite.play("Default")
	#print("Cloud life:", life)
	if life < 1:
		is_dead = true
		emit_signal("cloud_die")
		queue_free()
