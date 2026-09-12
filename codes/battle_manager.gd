extends Node

@onready var player = get_node("../Player")
@onready var cloud = preload("res://Enemy/cloud.tscn")
@onready var ballon = preload("res://Enemy/ballon.tscn")
@onready var victory_defeat = $"../UI/Victory_Defeat"
@onready var timer = $Timer
var can = true

func _ready() -> void:
	player.player_die.connect(endgame)
	start_round()

func start_round():
	can = true
	RoundManager.enemy_die = 0
	RoundManager.ballons_die = 0
	RoundManager.clouds_die = 0
	RoundManager.current_limit_enemy = 0
	RoundManager.clouds = 0
	RoundManager.ballons = 0
	if RoundManager.current_round > RoundManager.limit_round:
		endgame(false)
		return
	if RoundManager.current_round >= 3:
		@warning_ignore("integer_division")
		RoundManager.limit_cloud = (RoundManager.current_round - 1) / 2
	else:
		RoundManager.limit_cloud = 0
	timer.start()
	RoundManager.timer_cout += 1

func _on_timer_timeout() -> void:
	# Se já atingiu o número total de inimigos da wave,
	# não cria mais nada.
	if RoundManager.current_limit_enemy >= RoundManager.limit_enemy:
		timer.stop()
		return
	var should_spawn_cloud = (
		RoundManager.current_round >= 3
		and RoundManager.clouds < RoundManager.limit_cloud
	)
	if should_spawn_cloud:
		var boss = cloud.instantiate()
		boss.position = Vector2(500, -100)
		add_child(boss)
		boss.connect("cloud_die", Callable(self, "cloud_die"))
		RoundManager.current_limit_enemy += 1
		RoundManager.clouds += 1
	var enemy = ballon.instantiate()
	enemy.position = Vector2(500, -100)
	add_child(enemy)
	enemy.connect("ballon_die", Callable(self, "ballon_die"))
	RoundManager.current_limit_enemy += 1
	RoundManager.ballons += 1
	if RoundManager.current_limit_enemy == RoundManager.limit_enemy:
		timer.stop()
	if RoundManager.current_limit_enemy > RoundManager.limit_enemy:
		enemy.queue_free()
	print("-----------------------")
	print("inimigos spawnados: ", RoundManager.current_limit_enemy)
	print("limite: ", RoundManager.limit_enemy)
	print("clouds: ", RoundManager.clouds)
	print("ballons: ", RoundManager.ballons)

func ballon_die():
	RoundManager.ballons_die += 1
	check_limit_enemy()

func cloud_die():
	RoundManager.clouds_die += 1
	check_limit_enemy()

func check_limit_enemy():
	if !can:
		return
	RoundManager.enemy_die = RoundManager.ballons_die + RoundManager.clouds_die
	print("enemy die:", RoundManager.enemy_die)
	if RoundManager.enemy_die == RoundManager.limit_enemy:
		can = false
		RoundManager.current_round += 1
		RoundManager.limit_enemy += 1
		timer.stop()
		$"../UI".show_options()
		print("Round atual: ", RoundManager.current_round)
		print("Round limite: ", RoundManager.limit_round)
		await Globalsignal.powerup_selected
		start_round()

func endgame(_player_dead: bool):
	if _player_dead:
		victory_defeat.text = "DEFEAT"
	else:
		victory_defeat.text = "VICTORY"
	victory_defeat.visible = true
	await get_tree().create_timer(2).timeout
	RoundManager.enemy_die = 0
	RoundManager.ballons_die = 0
	RoundManager.clouds_die = 0
	RoundManager.current_limit_enemy = 0
	RoundManager.limit_enemy = 1
	RoundManager.limit_cloud = 0
	RoundManager.current_round = 0
	get_tree().change_scene_to_file("res://menu.tscn")
