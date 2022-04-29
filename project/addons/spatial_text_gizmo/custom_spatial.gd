tool
extends Spatial

export var visible_in_editor = true setget toggle_vis
export var size:float = 2 setget set_size
export var text = "Text"
onready var label = ViewportText.new()
var custom_ui_control

func _ready():
	var owner = get_tree().edited_scene_root
	print(owner)
	
	if not owner.get_node("custom_ui_control"):
		var node = Control.new()
		owner.add_child(node)
		node.set_owner(get_tree().edited_scene_root)
		
		node.name = "custom_ui_control"
		node.theme = Theme.new()
		node.rect_size = get_viewport().size
		node.anchor_right = 1
		node.anchor_bottom = 1
		node.add_to_group("custom_ui_control")
		custom_ui_control = node
	
	custom_ui_control = owner.get_node("custom_ui_control")
	custom_ui_control.add_child(label)
	label.set_owner(get_tree().edited_scene_root)
	label.update()
	
func _exit_tree():
	label.free()
	if owner.get_node("custom_ui_control").get_children().size() == 0:
		owner.get_node("custom_ui_control").free()

func toggle_vis(value):
	visible_in_editor = value
	gizmo.set_hidden(!value)
	update_gizmo()
	
func set_size(value):
	gizmo.gizmo_size = value
	size = value
