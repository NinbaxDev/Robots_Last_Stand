extends TextureProgressBar

func _process(_delta) -> void:
	max_value = PlayerData.max_life
	value = PlayerData.life
