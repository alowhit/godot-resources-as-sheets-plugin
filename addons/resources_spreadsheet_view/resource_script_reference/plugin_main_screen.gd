@tool
extends MarginContainer

@export var editor_view : Control

@export var file_dialog : FileDialog
@export var alert_dialog : AcceptDialog

@export var item_list : ItemList

@onready var selection = $SelectionActions

func _on_file_dialog_confirmed() -> void:
	#print(file_dialog.current_path)
	var _s = file_dialog.current_path
	var MyClass = load(_s)
	var instance = MyClass.new()
	if not instance.is_class("Resource"):
		var _screen_rect := DisplayServer.screen_get_usable_rect(alert_dialog.current_screen)
		alert_dialog.dialog_text = "File \"%s\" is not \"Resource\" Script!!" % _s
		alert_dialog.position = Vector2(_screen_rect.size.x/2, _screen_rect.size.y / 2)
		alert_dialog.show()
		return
	#var v = "Node"
	#if has_theme_icon(v, "EditorIcons"):
		#v = get_theme_icon(v, "EditorIcons")
	#item_list.add_item(file_dialog.current_path, v)
	item_list.fill([instance])
	print("File \"%s\" is added." % _s)
	


func _on_add_resource_button_pressed() -> void:
	file_dialog.show()


func _on_button_create_resource_pressed() -> void:
	#print(item_list.selected_builtin)
	#print(item_list.selected_script)
	if item_list.is_anything_selected():
		selection.open()
		selection._on_Duplicate_pressed()
	

func create_resource(name_input : String, arg: Array = []):
	var _path = editor_view.current_path + name_input + ".tres"
	var o : Object
	if ResourceLoader.has_cached(_path):
		o = ResourceLoader.get_cached_ref(_path)
		print("NOTICE: THIS IS FROM CACHED, SO THERE MUST BE ERROR ON REFERENCE")
	if item_list.selected_script != null:
		if o == null:
			o = Resource.new()
		o.set_script(item_list.selected_script)
		#print(o.get_script().get_global_name())
	elif item_list.selected_builtin != &"":
		o = ClassDB.instantiate(item_list.selected_builtin)
	ResourceSaver.save(o, _path)

func _on_editor_view_grid_updated() -> void:
	#print(editor_view.rows)
	item_list.fill(editor_view.rows)
