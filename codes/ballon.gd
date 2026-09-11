extends CharacterBody2D

signal ballon_die
@export var SPEED := 100.0
@export var left_limit := 50.0
@export var right_limit := 1100.0
@export var vertical_limit := 200.0
@export var shoot_interval := 1.5
@export var pattern_type := 0
@onready var thunder_scene = preload("res://thunder.tscn")
@onready var player = null
@onready var timer = $Timer
@onready var sprite = $AnimatedSprite2D
var life
var change = 0
var direction := 1
var is_dead = false

func _ready():
	life = EnemyData.life2
	sprite.play("Default")
	timer.wait_time = shoot_interval
	timer.start()
	player = get_tree().get_root().get_node("Main/Player")

func _physics_process(delta):
	if not player:
		return
	var direction_to_player = (player.global_position - global_position).normalized()
	# Movimento lateral + movimento vertical limitado
	var new_position = global_position + direction_to_player * SPEED * delta
	if new_position.y > vertical_limit:
		new_position.y = vertical_limit
	global_position = new_position

func _on_timer_timeout() -> void:
	shoot_aimed()

func shoot_line():
	for i in range(1):
		var thunder = thunder_scene.instantiate()
		var offset = Vector2(i * 32 - 64, 0)
		thunder.global_position = global_position + offset
		get_parent().add_child(thunder)
	change += 1
	if change >= 90:
		pattern_type += 1
		change = 0

func shoot_aimed():
	if not player:
		return
	var thunder = thunder_scene.instantiate()
	thunder.global_position = global_position
	var directionb = (player.global_position - global_position).normalized()
	if thunder.has_method("set_direction"):
		thunder.set_direction(directionb)
	else:
		thunder.direction = directionb  # se usar uma variável diretamente
	get_parent().add_child(thunder)

func increases_enemy():
	var lifeup = 4
	var damageup = 6
	if RoundManager.current_round == lifeup:
		EnemyData.life2 += 1
		lifeup += 4
	if RoundManager.current_round == damageup:
		EnemyData.damageB += 1
		damageup += 6

func take_damage(damage: int):
	if is_dead:
		return
	$AudioStreamPlayer2D.play()
	life -= damage
	sprite.play("Hit")
	await get_tree().create_timer(0.3).timeout
	if life == 5:
		sprite.play("hit1")
	if life == 4:
		sprite.play("hit2")
	if life == 3:
		sprite.play("hit3")
	if life == 2:
		sprite.play("hit4")
	if life == 1:
		sprite.play("hit5")
	if life < 1:
		sprite.play("hit6")
		is_dead = true
		emit_signal("ballon_die")
		await get_tree().create_timer(0.2).timeout
		queue_free()
