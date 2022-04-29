class_name terrain_chunk
extends Spatial

var chunk_settings
var chunk_noise_layers
var features = []
var mesh
var material
var dispatch_node


func _init(position,settings,passed_noise_layers,mat):
	transform.origin = position
	chunk_noise_layers = passed_noise_layers
	chunk_settings = settings
	material = mat

func initialize(queue):
	for child in get_children():
		if child is terrain_mesh:
			child.queue_free()
	
	mesh = terrain_mesh.new()
	mesh.material_override = material
	#mesh.generate_mesh(chunk_settings,global_transform.origin,chunk_noise_layers,features)
	add_child(mesh)
	queue.dispatch(mesh,"generate_mesh",[chunk_settings,global_transform.origin,chunk_noise_layers,features])
	#print(mesh)
	#mesh.set_owner(get_tree().edited_scene_root)
	
