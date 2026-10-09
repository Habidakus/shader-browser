extends OmniLight3D

var _time: float = 0.0
const SPEED: float = 1.2
const RADIUS: float = 2.6

func _process(delta: float) -> void:
	_time += delta * SPEED
	position.x = sin(_time) * RADIUS
	position.y = cos(_time) * RADIUS
