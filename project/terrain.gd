extends Spatial

var dispatch_queue

var settings = {
	"res" : 16,
	"size" : 8.0,
	} setget update_settings

var noise_layers = [preload("res://noise_layer1.tres"),preload("res://noise_layer2.tres")]

export var material:Material

var delete_chunks = false setget reset_chunks

var terrain_chunks = []
var features_node

func _ready():
	pass
	
func reset_chunks(_value):
	for node in get_children():
		node.free()
	
func update_settings(value):
	settings = value
	#update_chunks()

func update_noise_layers(value):
	if noise_layers.size() < value.size():
		var n = noise_filter.new()
		#n.connect("changed",self,"update_chunks")
		n.noiseSeed = hash(n.get_rid())
		noise_layers.append(n)
	else:
		noise_layers = value
	
	#update_chunks()
	
func update_chunks():
	for chunk in terrain_chunks:
		chunk.chunk_settings = settings
		chunk.chunk_noise_layers = noise_layers
		chunk.initialize()
	
func create_terrain_chunk(position):
	#print("making chunk")
	var chunk = terrain_chunk.new(position,settings,noise_layers,material)
	add_child(chunk)
	#chunk.set_owner(get_tree().edited_scene_root)
	chunk.initialize(dispatch_queue)
	chunk.name = str(floor(position.x/settings.size)) + "," + str(floor(position.z/settings.size))
	terrain_chunks.append(chunk.name)
	#print(chunk.name)
	
#func queue_create_terrain_chunk(position):
#	print("queuing :" + str(position))
#	dispatch_queue.dispatch(self, "create_terrain_chunk", ["position"]).then(self, "result_callback")

func initialize_terrain_chunks():
	for chunk in terrain_chunks:
		chunk.initialize()

func set_features(node):
	features_node = node

