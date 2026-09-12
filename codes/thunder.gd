extends Area2D

@onready var anim_timer = $Timer
@export var SPEED := 150
var direction := Vector2.ZERO
var damage 

func _ready() -> void:
	anim_timer.start()

func _process(delta):
	position += direction * SPEED * delta
	if position.y > 600:  # limite da tela
		queue_free()

func _on_body_entered(_body: Node2D) -> void:
	damage = EnemyData.damageB
	if _body.is_in_group("Player"):
		_body.take_damage(damage)
		$collision_sprite.set_deferred("disabled", true)

func increases_damage():
	pass
func _on_timer_timeout() -> void:
	if $AnimatedSprite2D.animation == "left":
		$AnimatedSprite2D.play("right")
	else:
		$AnimatedSprite2D.play("left")
