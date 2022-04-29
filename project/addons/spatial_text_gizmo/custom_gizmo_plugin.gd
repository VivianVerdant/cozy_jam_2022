# MyCustomGizmoPlugin.gd
extends EditorSpatialGizmoPlugin

const MyCustomSpatial = preload("res://addons/spatial_text_gizmo/custom_spatial.gd")
const MyCustomGizmo = preload("res://addons/spatial_text_gizmo/custom_gizmo.gd")

var control_node = Control.new()

func get_name():
	return "text gizmo"
	
func _init():
	create_material("main", Color(1, 0, 0))
	create_handle_material("handles")
	create_icon_material("icon", preload("res://icon.png"), false, Color( 1, 1, 1, 1 ))


func create_gizmo(spatial):
	if spatial is MyCustomSpatial:
		return MyCustomGizmo.new()
	else:
		return null
		
