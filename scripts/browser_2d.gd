extends Control


var _materials: Array = [
	["Poisson Circle Fade", preload("res://2dShaders/poisson_circles.tres"), false],
	["Circle Lock", preload("res://2dShaders/circle_lock.tres"), false],
	["Wiggle Coil", preload("res://2dShaders/wiggle_coil.tres"), false],
	["Triangle Selection", preload("res://2dShaders/triangle_selection.tres"), false],
	["Pulse Red", preload("res://2dShaders/pulse.tres"), false],
	["Sound Waves", preload("res://2dShaders/sound_waves.tres"), false],
	["Clouds", preload("res://2dShaders/clouds.tres"), true],
	["Moving Oil", preload("res://2dShaders/moving_oil.tres"), true],
	["Firepit", preload("res://2dShaders/firepit.tres"), true],
	["Circuit", preload("res://2dShaders/circuit.tres"), true],
	["Glowing Edge", preload("res://2dShaders/glowing-edge.tres"), true],
	["Flow", preload("res://2dShaders/flow.tres"), true],
	["Scrolling", preload("res://2dShaders/scrolling.tres"), false],
	["Rounded Corners", preload("res://2dShaders/rounded_corners.tres"), false],
	["Waggly Edges", preload("res://2dShaders/waggly_edges.tres"), false],
	["Ponderosa", preload("res://2dShaders/ponderosa.tres"), true],
	["Scrolling Hash", preload("res://2dShaders/scrolling_hash.tres"), false],
	["Contracting Circle", preload("res://2dShaders/contracting_circle.tres"), false],
	["Directional Pulse", preload("res://2dShaders/directional_pulse.tres"), true],
	["Planetary Alignment Timer", preload("res://2dShaders/planet_alignment.tres"), false],
	["Color Interior", preload("res://2dShaders/color_interior.tres"), false],
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
