extends Control


var _materials: Array = [
	["Poisson Circle Fade", preload("res://2dShaders/poisson_circles.tres")],
	["Circle Lock", preload("res://2dShaders/circle_lock.tres")],
	["Wiggle Coil", preload("res://2dShaders/wiggle_coil.tres")],
	["Triangle Selection", preload("res://2dShaders/triangle_selection.tres")],
]
var _index: int = 0;


func _ready() -> void:
	_setup_images()


func _setup_images() -> void:
	%ShaderName.text = _materials[_index][0]
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
