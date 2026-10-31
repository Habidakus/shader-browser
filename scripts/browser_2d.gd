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
	["Drifing Fog", preload("res://2dShaders/drifting_fog.tres"), false],
	["Random Blue Lumps", preload("res://2dShaders/random_blue_lumps.tres"), true],
	["HSV Cycle", preload("res://2dShaders/hsv_cycle.tres"), false],
	["Double Poisson", preload("res://2dShaders/double_poisson.tres"), true],
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
	_setup_controls(_materials[_index][1])


func _get_shader_paramter(c_material: ShaderMaterial, uniform: Dictionary) -> Variant:
	var current_value = c_material.get_shader_parameter(uniform["name"])
	if current_value != null:
		return current_value
	if uniform.has("default_value"):
		return uniform["default_value"]
	return null

func _setup_controls(c_material: ShaderMaterial) -> void:
	var shader: Shader = c_material.shader
	var controls_list: GridContainer = %ControlsList
	for child: Node in controls_list.get_children():
		controls_list.remove_child(child)
		child.queue_free()
	var uniforms: Array = shader.get_shader_uniform_list()
	for uniform: Dictionary in uniforms:
		var label_name: Label = Label.new()
		var uniform_name: String = uniform["name"]
		label_name.text = uniform_name
		controls_list.add_child(label_name)
		var uniform_type: int = uniform["type"]
		if uniform_type == TYPE_FLOAT:
			var line_edit: LineEdit = LineEdit.new()
			line_edit.text = str(_get_shader_paramter(c_material, uniform))
			line_edit.text_changed.connect(_on_float_text_changed.bind(c_material, uniform, line_edit))
			controls_list.add_child(line_edit)
		elif uniform_type == TYPE_INT:
			var line_edit: LineEdit = LineEdit.new()
			line_edit.text = str(_get_shader_paramter(c_material, uniform))
			line_edit.text_changed.connect(_on_int_text_changed.bind(c_material, uniform, line_edit))
			controls_list.add_child(line_edit)
		elif uniform_type == TYPE_OBJECT:
			var label_type: Label = Label.new()
			var hint_string: String = uniform["hint_string"]
			if hint_string.is_empty():
				label_type.text = type_string(uniform_type)
			else:
				label_type.text = hint_string
			controls_list.add_child(label_type)
		elif uniform_type == TYPE_COLOR:
			var color = _get_shader_paramter(c_material, uniform)
			if color == null:
				var label_color: Label = Label.new()
				label_color.text = "ERROR: %s" % (type_string(uniform_type))
				controls_list.add_child(label_color)
			elif color is Color:
				var color_picker_button: ColorPickerButton = ColorPickerButton.new()
				color_picker_button.color = color
				color_picker_button.color_changed.connect(_on_color_changed.bind(c_material, uniform))
				controls_list.add_child(color_picker_button)
			else:
				var label_color: Label = Label.new()
				label_color.text = str(color)
				controls_list.add_child(label_color)
		elif uniform_type == TYPE_BOOL:
			var bool_toggle: Button = CheckButton.new()
			var current_setting: bool = _get_shader_paramter(c_material, uniform)
			bool_toggle.button_pressed = current_setting
			bool_toggle.text = "On" if current_setting else "Off"
			bool_toggle.toggled.connect(_on_bool_toggled.bind(c_material, uniform, bool_toggle))
			controls_list.add_child(bool_toggle)
		elif (uniform_type == TYPE_VECTOR2
			or uniform_type == TYPE_VECTOR2I
			or uniform_type == TYPE_VECTOR3
			or uniform_type == TYPE_VECTOR3I
			or uniform_type == TYPE_VECTOR4
			or uniform_type == TYPE_VECTOR4I
			):
			var label_vector: Label = Label.new()
			label_vector.text = str(_get_shader_paramter(c_material, uniform))
			controls_list.add_child(label_vector)
		else:
			var label_type: Label = Label.new()
			label_type.text = type_string(uniform_type)
			controls_list.add_child(label_type)


func _on_int_text_changed(new_text: String, c_material: ShaderMaterial, uniform: Dictionary, line_edit: LineEdit) -> void:
	var new_int: int = int(new_text)
	var matches: bool = str(new_int) == new_text
	if matches:
		c_material.set_shader_parameter(uniform["name"], new_int)
	else:
		while matches == false:
			new_text = new_text.left(-1)
			if new_text.is_empty():
				matches = true
			else:
				matches = str(new_int) == new_text
		line_edit.set_block_signals(true)
		line_edit.text = new_text
		line_edit.set_block_signals(false)


func _on_float_text_changed(new_text: String, c_material: ShaderMaterial, uniform: Dictionary, line_edit: LineEdit) -> void:
	var new_float: float = float(new_text)
	var matches: bool = str(new_float) == new_text or str(int(new_float)) == new_text or ("%s." % [int(new_float)]) == new_text
	if matches:
		c_material.set_shader_parameter(uniform["name"], new_float)
	else:
		while matches == false:
			new_text = new_text.left(-1)
			if new_text.is_empty():
				matches = true
			else:
				matches = str(new_float) == new_text or str(int(new_float)) == new_text or ("%s." % [int(new_float)]) == new_text
		line_edit.set_block_signals(true)
		line_edit.text = new_text
		line_edit.set_block_signals(false)


func _on_color_changed(new_color: Color, c_material: ShaderMaterial, uniform: Dictionary) -> void:
	c_material.set_shader_parameter(uniform["name"], new_color)


func _on_bool_toggled(toggled_on: bool, c_material: ShaderMaterial, uniform: Dictionary, bool_toggle: Button) -> void:
	c_material.set_shader_parameter(uniform["name"], toggled_on)
	bool_toggle.text = "On" if toggled_on else "Off"


func _on_next_button_button_up() -> void:
	_index = (_index + 1) % _materials.size()
	_setup_images()


func _on_previous_button_button_up() -> void:
	_index = (_index + _materials.size() - 1) % _materials.size()
	_setup_images()
