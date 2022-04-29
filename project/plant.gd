extends Spatial

onready var anim_player = $animation_player
var done_growing = false

func _ready():
	rotate_y(deg2rad(randf()*360))
	anim_player.speed = (randf()-.5)*.25+1
	anim_player.play("grow")
	print("growing")

func grow_towards(nearby_plants):
	return
	for plant in nearby_plants:
		print("growing towards " + str(plant))

func _process(delta):
	if not done_growing:
		rotate_y(deg2rad(randf()*360))
		anim_player.playback_speed = (randf()-.5)*.25+1
		anim_player.play("grow")
		#print("growing")
		done_growing = true
		for node in get_tree().get_nodes_in_group("leaf"):
			node.visible = true
