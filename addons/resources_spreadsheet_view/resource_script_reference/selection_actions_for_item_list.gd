@tool
extends MarginContainer

enum {
	EDITBOX_DUPLICATE = 1,
	EDITBOX_RENAME,
	EDITBOX_DELETE,
}

const TextEditingUtilsClass := preload("res://addons/resources_spreadsheet_view/text_editing_utils.gd")
const TablesPluginSettingsClass := preload("res://addons/resources_spreadsheet_view/settings_grid.gd")

#@onready var editor_view := $"../.."
#@onready var selection := $"../../SelectionManager"
@export var main_screen : Control
@export var editor_view : Control
@export var item_list : ItemList

@onready var editbox_node := $"Control/ColorRect/Popup"
@onready var editbox_label : Label = editbox_node.get_node("Panel/VBoxContainer/Label")
@onready var editbox_input : LineEdit = editbox_node.get_node("Panel/VBoxContainer/LineEdit")

#var cell : Control
var editbox_action : int


func _ready():
	editbox_input.get_node("../..").add_theme_stylebox_override(
		"panel",
		get_theme_stylebox(&"Content", &"EditorStyles")
	)
	editbox_input.text_submitted.connect(func(_new_text): _on_editbox_accepted())
	close()



func open(txt: String = ""):
	set_deferred(&"global_position", get_global_mouse_position() + Vector2.ONE)

	show()
	size = Vector2.ZERO
	top_level = true
	$"Control2/Label".text = txt


func close():
	_on_editbox_closed()
	hide()


func _on_Duplicate_pressed():
	_show_editbox(EDITBOX_DUPLICATE)

func _on_Delete_pressed():
	_show_editbox(EDITBOX_DELETE)


func _show_editbox(action):
	editbox_action = action
	match action:
		EDITBOX_DUPLICATE:
			editbox_label.text = "Input new resource's name..."
			editbox_input.text = ""


		EDITBOX_DELETE:
			editbox_label.text = "Really delete selected rows?"
			editbox_input.text = item_list.get_item_text(item_list.get_selected_items()[0])
			#editor_view.get_last_selected_row()\
				#.resource_path.get_file().get_basename()
	
	show()
	editbox_input.grab_focus()
	editbox_input.caret_column = 999999999
	editbox_node.size = Vector2.ZERO
	editbox_node.show()
	$"Control/ColorRect".show()
	$"Control/ColorRect".top_level = true
	$"Control/ColorRect".size = get_viewport_rect().size * 4.0
	editbox_node.global_position = (
		global_position
		+ size * 0.5
		- editbox_node.get_child(0).size * 0.5
	)


func _on_editbox_closed():
	editbox_node.hide()
	$"Control/ColorRect".hide()
	hide()

func _on_editbox_accepted():
	match(editbox_action):
		EDITBOX_DUPLICATE:
			#editor_view.duplicate_selected_rows(editbox_input.text)
			main_screen.create_resource(editbox_input.text)

		EDITBOX_DELETE:
			item_list.remove_item_data(item_list.get_selected_items()[0])

	_on_editbox_closed()
	close()
