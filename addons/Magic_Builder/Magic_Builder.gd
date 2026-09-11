@tool
extends EditorPlugin

var screen
const tool_menu = preload("res://addons/Magic_Builder/tool_menu.tscn")

func _enter_tree() -> void:
	screen = tool_menu.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BL, screen)

func _exit_tree() -> void:
	remove_control_from_docks(screen)
	screen.queue_free()
