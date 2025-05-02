extends ResourceTablesCellEditor


func can_edit_value(value, type, property_hint, property_hint_string, column_index) -> bool:
	var _can_edit_value := super.can_edit_value(value, type, property_hint, property_hint_string, column_index)
	#if type == TYPE_PACKED_STRING_ARRAY or type == TYPE_ARRAY:
		#if property_hint == PROPERTY_HINT_TYPE_STRING:
			##print(value, ",", type, ",", property_hint, ",",property_hint_string, ",", column_index)
			#if property_hint_string[0].begins_with("24/17"):
				##print("Array from ", column_index, " can't edit")
				#return false
	return _can_edit_value

func to_text(value) -> String:
	return str(value)


func from_text(text : String):
	return text


func set_color(node : Control, color : Color):
	node.get_node("Back").modulate = color * 0.6
