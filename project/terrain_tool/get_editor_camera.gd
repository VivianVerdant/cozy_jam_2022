extends Node

var editor_viewport_2d
var editor_viewport_3d
var editor_camera_3d

func _ready():
	editor_viewport_2d = find_viewport_2d(get_node("/root/EditorNode"), 0)
	editor_viewport_3d = find_viewport_3d(get_node("/root/EditorNode"), 0)
	editor_camera_3d = editor_viewport_3d.get_child(0)


func find_viewport_2d(node: Node, recursive_level):
	if node.get_class() == "CanvasItemEditor":
		return node.get_child(1).get_child(0).get_child(0).get_child(0).get_child(0)
	else:
		recursive_level += 1
		if recursive_level > 15:
			return null
		for child in node.get_children():
			var result = find_viewport_2d(child, recursive_level)
			if result != null:
				return result


func find_viewport_3d(node: Node, recursive_level):
	if node.get_class() == "SpatialEditor":
		return node.get_child(1).get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	else:
		recursive_level += 1
		if recursive_level > 15:
			return null
		for child in node.get_children():
			var result = find_viewport_3d(child, recursive_level)
			if result != null:
				return result
