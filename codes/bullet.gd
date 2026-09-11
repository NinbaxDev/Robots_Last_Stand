extends Node2D

@export var SPEED = 300.0 
@onready var anim_timer = $Timer

func _ready() -> void:
	anim_timer.start()

func _process(delta: float) -> void:
	position += transform.x * SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("Enemy"):
		_body.take_damage(PlayerData.attack)
		queue_free()

func _on_timer_timeout() -> void:
	if $AnimatedSprite2D.animation == "D1":
		$AnimatedSprite2D.play("D2")
	else:
		$AnimatedSprite2D.play("D1")
