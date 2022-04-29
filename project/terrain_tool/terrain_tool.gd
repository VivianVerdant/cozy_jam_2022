tool
extends Spatial

export var chunk_size :int = 1
export var terrain_size :int = 10
export var show_lod_labels :bool = true
export var update: bool = false setget update_terrain
var lod_ui = []
var terrain_ui
var editor_viewport_3d
var editor_camera_3d
var current_camera

onready var viewport = $viewport

func _ready():
	pass
	

func update_terrain(value):
	if not terrain_ui:
		terrain_ui = Spatial.new()
		add_child(terrain_ui)
		terrain_ui.set_owner(get_tree().edited_scene_root)
	
	if (terrain_size*terrain_size != lod_ui.size()):
		for n in lod_ui:
			lod_ui.pop_at(lod_ui.find(n))
			n.queue_free()
		
		for y in terrain_size:
			for x in terrain_size:
				var label = lod_label.new()
				lod_ui.append(label)
				terrain_ui.add_child(label)
				label.name = str(x) + "_" + str(y)
				label.global_transform.origin = Vector3(x*chunk_size+(chunk_size as float/2),0,y*chunk_size+(chunk_size as float/2))
				label.set_owner(get_tree().edited_scene_root)
				#print(label.global_transform.origin)
			
func get_editor_camera(node: Node, recursive_level):
	if node.get_class() == "SpatialEditor":
		return node.get_child(1).get_child(0).get_child(0).get_child(0).get_child(0).get_child(0)
	else:
		recursive_level += 1
		if recursive_level > 15:
			return null
		for child in node.get_children():
			var result = get_editor_camera(child, recursive_level)
			if result != null:
				return result
	

func update_lod_labels():
	if lod_ui.size() == 0:
		return
	
func _process(_delta):
	if show_lod_labels and lod_ui.size() > 0:
		update_lod_labels()
