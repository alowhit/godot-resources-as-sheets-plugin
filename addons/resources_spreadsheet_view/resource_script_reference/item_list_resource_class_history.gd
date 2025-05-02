@tool
extends ItemList

#@onready var editor_view := $"../../../../.."
#@onready var node_options := $"Class"
#@onready var node_subclasses_check := $"Subclasses"
@onready var lineEditFilter : LineEdit = $"../LineEdit"

var found_builtins : Array[String] = []
var found_scripts : Array[Script] = []
var display_item_list : Array[String] = []
var selected_builtin := &""
var selected_script : Script
var selected_is_valid := false
var include_subclasses := true


func _ready():
	item_selected.connect(_on_item_selected)

func fill(resources : Array):
	#found_scripts.clear()
	#found_builtins.clear()
	var class_set := {}
	for x in resources:
		class_set[x.get_script()] = true
		class_set[StringName(x.get_class())] = true
		var current_s : Script = x.get_script()
		while current_s != null:
			current_s = current_s.get_base_script()
			if class_set.has(current_s):
				break

			class_set[current_s] = true

		var current_c : StringName = x.get_class()
		while true:
			if current_c == &"Resource":
				break

			current_c = ClassDB.get_parent_class(current_c)
			if class_set.has(current_c):
				break

			class_set[current_c] = true

	class_set.erase(null)
	class_set.erase("Resource")

	for k in class_set:
		if k is StringName and not found_builtins.has(k):
			found_builtins.append(k)

		if k is Script and not found_scripts.has(k):
			found_scripts.append(k)
	
	refresh()

	# Filter is disabled if the already selected class is not in the set.
	if not class_set.has(selected_script) and not class_set.has(selected_builtin):
		selected_is_valid = false

	show()

func refresh():
	
	tooltip_text = ""
	deselect_all()
	clear()
	display_item_list.clear()
	var icon = []
	# Add builtins, then script classes, in order.
	for x in found_builtins:
		display_item_list.append(x)
		if has_theme_icon(x, &"EditorIcons"):
			#set_item_icon(-1, get_theme_icon(x, &"EditorIcons"))
			icon.append(get_theme_icon(x, &"EditorIcons"))
		else:
			#set_item_icon(-1, get_theme_icon(&"Object", &"EditorIcons"))
			icon.append(get_theme_icon(&"Object", &"EditorIcons"))

	for x in found_scripts:
		display_item_list.append(x.get_global_name())
		#set_item_icon(-1, get_theme_icon(&"Script", &"EditorIcons"))
		icon.append(get_theme_icon(&"Script", &"EditorIcons"))
	
	for text in display_item_list:
		if lineEditFilter.text.to_lower() in text.to_lower() or lineEditFilter.text.is_empty():
			var index := display_item_list.find(text)
			add_item(text, icon[index])
		#print(text)

#func clear_list():
	#selected_is_valid = false


func filter(resource : Resource) -> bool:
	if not selected_is_valid:
		return true

	if resource.get_class() != selected_builtin:
		if include_subclasses and selected_script == null:
			var cur_class := StringName(resource.get_class())
			while cur_class != &"Object":
				cur_class = ClassDB.get_parent_class(cur_class)
				if cur_class == selected_builtin:
					return true

		return false

	if selected_script != null and resource.get_script() != selected_script:
		if include_subclasses:
			var cur_class : Script = resource.get_script()
			while cur_class != null:
				cur_class = cur_class.get_base_script()
				if cur_class == selected_script:
					return true

		return false


	return true


func _on_item_selected(index : int):
	#print(index)
	#if index == 0:
		#selected_builtin = &""
		#selected_script = null
		#selected_is_valid = false
	
	var item_text := get_item_text(index)
	#print(found_scripts[0].get_global_name())
	#print(found_scripts.find_custom(func(x): return x.get_global_name() == item_text))
	
	var buildin_index := found_builtins.find(item_text)
	#print(buildin_index)
	if buildin_index > -1:
		selected_builtin = found_builtins[buildin_index]
		selected_script = null
		selected_is_valid = true

	else:
		var script_index := found_scripts.find_custom(func(x): return x.get_global_name() == item_text)
		selected_script = found_scripts[script_index]
		selected_builtin = selected_script.get_instance_base_type()
		selected_is_valid = true

	tooltip_text = "Selected: %s" % get_item_text(index)
	#editor_view.refresh()
	#TODO: refresh footer buttons


func _on_line_edit_text_changed(new_text: String) -> void:
	refresh()

func remove_item_data(_i : int) -> void:
	var _t = get_item_text(_i)
	remove_item(_i)
	if selected_builtin != &"":
		found_builtins.erase(selected_builtin)
	if selected_script != null:
		found_scripts.erase(selected_script)
	selected_builtin = &""
	selected_script = null
	selected_is_valid = false
