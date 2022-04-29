extends Spatial

var dispatch_queue

onready var focus_node = $player
var focus_position

onready var terrain_node = $terrain
var path_features
export var explored = []
var current_cell

onready var plant_scene = preload("res://plant.tscn")

onready var tree_gobo = $dapple_shadows

const GEN_SIZE = 5
const HALF_GEN_SIZE = floor(GEN_SIZE/2)
#export var reset_explored = false setget reset_explored

func _ready():
	reset_explored(0)
	OS.center_window()
	if not dispatch_queue:
		dispatch_queue = preload("res://addons/dispatch_queue/dispatch_queue_resource.gd").new()
		dispatch_queue.thread_count = 1
		dispatch_queue.connect("all_tasks_finished",self,"done_loading")
		terrain_node.dispatch_queue = dispatch_queue

func reset_explored(_value):
	explored = []
	#terrain_node.terrain_chunks = []
	if terrain_node:
		for node in terrain_node.get_children():
			node.free()


func _process(_delta):

	if not focus_node:
		focus_node = $player

	if not terrain_node:
		terrain_node = $terrain

	if focus_node.translation != focus_position:
		focus_position = focus_node.translation
		current_cell = Vector2(floor(focus_position.x/terrain_node.settings.size),floor(focus_position.z/terrain_node.settings.size))
		if not explored.has(current_cell):
			#print(current_cell)
			explored.append(current_cell)
			if not path_features:
				path_features = $features
			#terrain_node.set_features(path_features)
			#terrain_node.create_terrain_chunk(Vector3(current_cell.x*terrain_node.settings.size,0,current_cell.y*terrain_node.settings.size))
			for x in GEN_SIZE:
				for y in GEN_SIZE:
					if not terrain_node.terrain_chunks.has(str(current_cell.x+x-HALF_GEN_SIZE) + "," + str(current_cell.y+y-HALF_GEN_SIZE)):
						terrain_node.create_terrain_chunk(Vector3((current_cell.x+x-HALF_GEN_SIZE)*terrain_node.settings.size,0,(current_cell.y+y-HALF_GEN_SIZE)*terrain_node.settings.size))

func done_loading():
	#print("done loading")
	focus_node.enabled = true
	terrain_node.dispatch_queue.disconnect("all_tasks_finished",self,"done_loading")
	get_node("loading_screen").visible = false

func _on_player_plant_step_taken(position,normal,nearby_plants):
	dispatch_queue.dispatch(self,"place_plant",[position,normal,nearby_plants])

func place_plant(position,normal,nearby_plants):
	var scn = plant_scene.instance()
	scn.translation = position
	scn.transform = align_with_y(scn.transform, normal)
	add_child(scn)
	scn.grow_towards(nearby_plants)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
