extends Node2D

@export_category("Characteristics")
@export var speed: float = 100
@export var damage: int = 0
@export var time_limit: int = 3
var element = "Fire"
var type = "Projectile"

func _ready() -> void:
	print("Element: ", element)
	print("Type: ", type)

func _process(_delta: float) -> void:
	position += transform.x * speed * _delta
	if Time.get_ticks_usec() == time_limit:
		queue_free()

func _on_hit_box_body_entered(body) -> void:
	if body.is_in_group("enemy"):
		print("-1 HP")
		print("Type of damage: ", element)
		queue_free()
