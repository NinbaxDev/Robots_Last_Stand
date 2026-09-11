extends AudioStreamPlayer

const music_level = preload("res://Sounds/Music/byte-blast-8-bit-arcade-music-background-music-for-video-208780.mp3")

func play_music(music: AudioStream, volume = -30.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()

func play_music_level():
	play_music(music_level)
	pass
