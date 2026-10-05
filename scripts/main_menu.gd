extends Control


var _browser_2d: PackedScene = preload("res://scenes/browser_2d.tscn")


func _on_browse_2d_button_up() -> void:
	get_tree().change_scene_to_packed(_browser_2d)
