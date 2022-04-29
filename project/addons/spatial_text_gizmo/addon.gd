tool
extends EditorPlugin

const MyCustomGizmoPlugin = preload("res://addons/spatial_text_gizmo/custom_gizmo_plugin.gd")
const control_ui = preload("res://addons/spatial_text_gizmo/control_ui.tscn")

var gizmo_plugin = MyCustomGizmoPlugin.new()
var main_panel_instance

func _enter_tree():
	add_spatial_gizmo_plugin(gizmo_plugin)
	add_custom_type("text gizmo", "Spatial", preload("custom_spatial.gd"), preload("icons/Label.svg"))
	
	main_panel_instance = control_ui.instance()
	set_force_draw_over_forwarding_enabled()


func _exit_tree():
	remove_spatial_gizmo_plugin(gizmo_plugin)
	remove_custom_type("text gizmo")
	
	if main_panel_instance:
		main_panel_instance.queue_free()


func forward_spatial_force_draw_over_viewport(overlay):
	# Draw a circle at cursor position.
	overlay.draw_circle(overlay.get_local_mouse_position(), 64, Color.red)

func forward_spatial_gui_input(camera, event):
	if event is InputEventMouseMotion:
		# Redraw viewport when cursor is moved.
		update_overlays()
		return true
	return false
