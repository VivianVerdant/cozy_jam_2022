extends Spatial

var enabled = false

onready var camera_reference = $camera_reference
onready var camera_ray_cast = $ray_cast
var dz = 0
var dy = 0
var dx = 0
var velocity

var gravity = 0.1
var friction = 0.05

const ACCELERATION = 0.05
const MAX_SPEED = 2.0
const CAM_HEIGHT_LERP = 0.01

signal plant_step_taken
const PLANT_STEP_SIZE = 1.5
var prev_step_location
var nearby_plants = []

func _ready():
	prev_step_location = Vector3.ZERO

func _process(_delta):
	if not enabled:
		return
		
	var current_position = Vector3(translation.x,camera_ray_cast.get_collision_point().y,translation.z)
	if prev_step_location.distance_to(current_position) > PLANT_STEP_SIZE:
		if nearby_plants.size() < 4:
			prev_step_location = current_position
			#print("step")
			var normal = camera_ray_cast.get_collision_normal()
			emit_signal("plant_step_taken",current_position,normal,nearby_plants)

func _physics_process(delta):
	if not enabled:
		return
		
	var x_axis = -Input.get_action_strength("Left") + Input.get_action_strength("Right")
	var y_axis = -Input.get_action_strength("Up") + Input.get_action_strength("Down")
		
	#var input_vector = Vector2(x_axis,y_axis)

	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()
	
#	if Vector2(x_axis,y_axis).length() > 1:
#		x_axis = Vector2(x_axis,y_axis).normalized().x
#		y_axis = Vector2(x_axis,y_axis).normalized().y
	
	dx += x_axis * ACCELERATION
	if abs(dx) > MAX_SPEED:
		dx = x_axis * MAX_SPEED
	dz += y_axis * ACCELERATION
	if abs(dz) > MAX_SPEED:
		dz = y_axis * MAX_SPEED
	
	if abs(x_axis) < 0.1:
		dx = lerp(dx,0,friction)
	if abs(y_axis) < 0.1:
		dz = lerp(dz,0,friction)
	
	velocity = Vector3(dx,dy,dz)

	translation.x += velocity.x*delta
	translation.z += velocity.z*delta
	
	camera_reference.translation.y = lerp(camera_reference.translation.y,to_local(camera_ray_cast.get_collision_point()).y,CAM_HEIGHT_LERP)


func _on_plant_area_entered(area):
	if area.is_in_group("plant"):
		nearby_plants.append(area)
	#print(nearby_plants)


func _on_plant_area_exited(area):
	if area in nearby_plants:
		nearby_plants.erase(area)
	#print(nearby_plants)
