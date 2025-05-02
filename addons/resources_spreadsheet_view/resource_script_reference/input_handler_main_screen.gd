@tool
extends Node

@onready var plugin_main_screen_view := get_parent()
@onready var item_list : ItemList = get_parent().get("item_list")
@onready var selection := $"../SelectionActions"

func _gui_input(event : InputEvent):
	if event is InputEventMouseButton:
		##if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			##selection.open()
#
		if event.button_index == MOUSE_BUTTON_LEFT:
			#plugin_main_screen_view.grab_focus()
			if !event.pressed:
				#item_list.deselect_all()
				selection.close()

#func _input(event : InputEvent):
	#if !event is InputEventKey or !event.pressed:
		#return
	#
	#if !plugin_main_screen_view.has_focus() or item_list.item_count == 0:
		#return
#
	#if event.keycode == KEY_CTRL or event.keycode == KEY_SHIFT or event.keycode == KEY_META:
		## Modifier keys do not get processed.
		#return
	#
	## Ctrl + Z (before, and instead of, committing the action!)
	#if event.is_command_or_control_pressed():
		#if event.keycode == KEY_Z or event.keycode == KEY_Y:
			#return
#
	#_key_specific_action(event)
	#plugin_main_screen_view.grab_focus()
	#plugin_main_screen_view.editor_view.editor_interface.get_resource_filesystem().scan()


func _on_item_list_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_RIGHT:
		item_list.select(index)
		selection.open()


func _on_item_list_empty_clicked(at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_RIGHT:
		if item_list.is_anything_selected():
			selection.open()
			return
	if item_list.has_focus():
		item_list.refresh()
		selection.close()
