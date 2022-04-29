tool
extends Spatial

export var cleanup_ui_control_node = false setget cleanup

func cleanup(value):
	var node = get_node("custom_ui_control")
	print(node)
	if node:
		for child in node.get_children():
			child.free()
		node.free()

func _ready():
	pass
