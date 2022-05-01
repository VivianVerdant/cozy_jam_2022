extends Spatial

onready var anim_player = $animation_player

#
#func _ready():
#	rotate_y(deg2rad(randf()*360))
#	anim_player.playback_speed = (randf()-.5)*.25+1
#	anim_player.play("grow")
#	print("growing")

func _ready():
	rotate_y(deg2rad(randf()*360))
	anim_player.playback_speed = (randf()-.5)*.25+1
	anim_player.play("grow")
	#print("growing")
	for node in get_tree().get_nodes_in_group("leaf"):
		node.visible = true
