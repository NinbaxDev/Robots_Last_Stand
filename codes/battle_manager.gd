extends Node

@onready var player = get_node("../Player")
@onready var cloud = preload("res://Enemy/cloud.tscn")
@onready var ballon = preload("res://Enemy/ballon.tscn")
@onready var victory_defeat = $"../UI/Victory_Defeat"
@onready var timer = $Timer
var can = false

func _ready() -> void:
	player.player_die.connect(player_die)
	start_round()

func start_round():
	can = false
	RoundManager.enemy_die = 0
	RoundManager.ballons_die = 0
	RoundManager.clouds_die = 0
	RoundManager.current_limit_enemy = 0
	if RoundManager.current_round > RoundManager.limit_round:
		comeback()
	else:
		if RoundManager.current_limit_enemy > RoundManager.limit_enemy:
			timer.stop()
		else:
			timer.start()

func _on_timer_timeout() -> void:
	var enemy = ballon.instantiate()
	enemy.position = Vector2(500, -100)
	add_child(enemy)
	enemy.connect("ballon_die", Callable(self, "ballon_die"))
	RoundManager.current_limit_enemy += 1
	if RoundManager.current_limit_enemy > RoundManager.limit_enemy + 1:
		enemy.queue_free()
		RoundManager.current_limit_enemy -= 1
	if RoundManager.current_round >= 3 && RoundManager.clouds == RoundManager.limit_enemy / 6:
		RoundManager.create_cloud = true
		RoundManager.limit_cloud += 1
	if RoundManager.create_cloud && RoundManager.clouds < RoundManager.limit_cloud:
		var boss = cloud.instantiate()
		boss.position = Vector2(500, -100)
		add_child(boss)
		boss.connect("cloud_die", Callable(self, "cloud_die"))
		RoundManager.current_limit_enemy += 1
		RoundManager.clouds += 1
		#RoundManager.create_cloud = false
		if RoundManager.current_limit_enemy > RoundManager.limit_enemy + 1:
			boss.queue_free()
			RoundManager.current_limit_enemy -= 1
	if RoundManager.current_limit_enemy > RoundManager.limit_enemy:
		timer.stop()
	print("limit:", RoundManager.current_limit_enemy)

func ballon_die():
	RoundManager.ballons_die += 1
	check_limit_enemy()

func cloud_die():
	RoundManager.clouds_die += 1
	check_limit_enemy()

func check_limit_enemy():
	can = true
	RoundManager.enemy_die = RoundManager.ballons_die + RoundManager.clouds_die
	print("enemy die:", RoundManager.enemy_die)
	print("limit enemy", RoundManager.limit_enemy)
	if RoundManager.enemy_die > RoundManager.limit_enemy && can:
		can = false
		RoundManager.current_round += 1
		RoundManager.limit_enemy += 1
		RoundManager.clouds = 0
		$"../UI".show_options()
		await Globalsignal.powerup_selected
		start_round()

func player_die(_player_dead: bool):
	victory_defeat.text = str("DEFEAT")
	victory_defeat.visible = true
	await get_tree().create_timer(2).timeout
	RoundManager.enemy_die = 1
	RoundManager.ballons_die = 0
	RoundManager.clouds_die = 0
	RoundManager.current_limit_enemy = 0
	RoundManager.limit_enemy = 2
	RoundManager.limit_cloud = 0
	RoundManager.current_round = 0
	RoundManager.create_cloud = false
	get_tree().change_scene_to_file("res://menu.tscn")

func comeback():
	victory_defeat.text = str("VICTORY")
	victory_defeat.visible = true
	await get_tree().create_timer(2).timeout
	victory_defeat.text = str("")
	victory_defeat.visible = false
	RoundManager.enemy_die = 0
	RoundManager.ballons_die = 0
	RoundManager.clouds_die = 0
	RoundManager.current_limit_enemy = 0
	RoundManager.limit_enemy = 2
	RoundManager.limit_cloud = 0
	RoundManager.current_round = 0
	RoundManager.create_cloud = false
	get_tree().change_scene_to_file("res://menu.tscn")
