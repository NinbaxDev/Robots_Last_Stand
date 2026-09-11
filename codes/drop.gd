extends Area2D

@export var SPEED := 150.0
@onready var anim_timer = $Timer

func _ready() -> void:
	anim_timer.start()

func _process(delta):
	position.y += SPEED * delta
	if position.y > 600:  # limite da tela
		queue_free()


func _on_body_entered(_body: Node2D) -> void:
	var damage = 1
	if _body.is_in_group("Player"):
		_body.take_damage(damage)
		$collision_sprite.set_deferred("disabled", true)


func _on_timer_timeout() -> void:
	if $AnimatedSprite2D.animation == "D1":
		$AnimatedSprite2D.play("D2")
	else:
		$AnimatedSprite2D.play("D1")
