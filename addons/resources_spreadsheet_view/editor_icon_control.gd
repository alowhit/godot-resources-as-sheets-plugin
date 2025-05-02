@tool
extends Control

@export var icon_name := "Node" :
	set(v):
		icon_name = v
		if has_theme_icon(v, "EditorIcons"):
			if is_class("Button"):
				set("icon",get_theme_icon(v, "EditorIcons"))
			if is_class("LineEdit"):
				set("right_icon",get_theme_icon(v, "EditorIcons"))
			#print(name)


func _ready():
	self.icon_name = (icon_name)
