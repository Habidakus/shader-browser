extends Control


var _materials: Array = [
	["Poisson Circle Fade", preload("res://2dShaders/poisson_circles.tres"), false],
	["Circle Lock", preload("res://2dShaders/circle_lock.tres"), false],
	["Wiggle Coil", preload("res://2dShaders/wiggle_coil.tres"), false],
	["Triangle Selection", preload("res://2dShaders/triangle_selection.tres"), false],
	["Pulse Red", preload("res://2dShaders/pulse.tres"), false],
	["Flow", preload("res://2dShaders/flow.tres"), true],
	["Sound Waves", preload("res://2dShaders/sound_waves.tres"), false],
	["Clouds", preload("res://2dShaders/clouds.tres"), true],
	["Moving Oil", preload("res://2dShaders/moving_oil.tres"), true],
]
var _index: int = 0;


func _ready() -> void:
	_setup_images()


func _setup_images() -> void:
	%ShaderName.text = _materials[_index][0]
	if _materials[_index][2]:
		%TextureRectBig.show()
		%TextureRectBig.material = _materials[_index][1]
		%TextureRect1.hide()
		%TextureRect2.hide()
		%TextureRect3.hide()
		%ColorRect.hide()
	else:
		%TextureRectBig.hide()
		%TextureRect1.show()
		%TextureRect2.show()
		%TextureRect3.show()
		%ColorRect.show()
		%TextureRect1.material = _materials[_index][1]
		%TextureRect2.material = _materials[_index][1]
		%TextureRect3.material = _materials[_index][1]
		%ColorRect.material = _materials[_index][1]


func _on_next_button_button_up() -> void:
	_index = (_index + 1) % _materials.size()
	_setup_images()


func _on_previous_button_button_up() -> void:
	_index = (_index + _materials.size() - 1) % _materials.size()
	_setup_images()
