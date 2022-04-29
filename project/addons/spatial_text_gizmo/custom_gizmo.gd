tool
extends EditorSpatialGizmo


# You can store data in the gizmo itself (more useful when working with handles).
var gizmo_size = 3.0
var text = "default"

func _init():
	pass

func redraw():
	clear()
	
	var lines = PoolVector3Array()

	lines.push_back(Vector3(0, 0, 0))
	lines.push_back(Vector3(0, 1, 0))
	
	lines.push_back(Vector3(0, 1, 0))
	lines.push_back(Vector3(.5, 1, 0))
	
	lines.push_back(Vector3(.5, 1, 0))
	lines.push_back(Vector3(.5, 0, 0))
	
	lines.push_back(Vector3(0, 0, 0))
	lines.push_back(Vector3(.5, 0, 0))

	var material = get_plugin().get_material("main", self)
	add_lines(lines, material, true)

# You should implement the rest of handle-related callbacks
# (get_handle_name(), get_handle_value(), commit_handle()...).
