extends Node

var powerups = {
	"Attack +1": func(): PlayerData.attack += 1,
	"Life +5": func(): PlayerData.max_life += 5; PlayerData.life = PlayerData.max_life,
	"Speed +10%": func(): PlayerData.velocity *= 1.1,
	"Attack Speed": func(): PlayerData.attack_speed -= 0.1
}

func get_random_powerups(count = 3) -> Array:
	var keys = powerups.keys()
	keys.shuffle()
	return keys.slice(0, count)

func apply_powerup(Powerup_name: String) -> void:
	if powerups.has(Powerup_name):
		powerups[Powerup_name].call()
		print("attack:", PlayerData.attack)
		print("life max:", PlayerData.max_life)
		print("velocity:", PlayerData.velocity)
		print("life:", PlayerData.life)
		print("Round", RoundManager.current_round)
