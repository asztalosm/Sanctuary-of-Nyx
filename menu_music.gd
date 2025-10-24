extends AudioStreamPlayer
static var musicvolume = 0.0
static var sfxvolume = 0.0

func _process(_delta) -> void:
	if musicvolume == -10:
		volume_db = -5000
	elif musicvolume < 0:
		volume_db = 0 + (musicvolume * 2)
	else:
		volume_db = musicvolume * 1.5

func setsfx():
	if musicvolume == -10:
		return -5000
	elif musicvolume < 0:
		return 0 + (musicvolume * 2)
	else:
		return musicvolume * 1.5
