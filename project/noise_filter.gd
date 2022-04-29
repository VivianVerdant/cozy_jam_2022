extends Resource
class_name noise_filter

var noise = OpenSimplexNoise.new()
export var enabled = true setget updateEnabled
export(float,0,100) var scale = 1 setget updateScale
export var roughness:float = 1 setget updateRoughness
export(int,1,9) var octaves = 1 setget updateOctaves
export var center = Vector3.ZERO setget updateCenter
export var offset:float = 0 setget updateOffset
export var noiseSeed = 1 setget updateNoise
export var randomizeSeed = false setget randSeed


func evaluate(point:Vector3):
	var freq = Vector3(roughness,roughness,roughness)
	noise.octaves = octaves
	noise.seed = noiseSeed
	var noiseValue:float = noise.get_noise_3dv(point*freq+center)*scale-offset
	#print(noiseValue)
	return noiseValue
	
func evaluate_with_neighbors(point:Vector3):
	var freq = Vector3(roughness,roughness,roughness)
	noise.octaves = octaves
	noise.seed = noiseSeed
	var noiseValue:float = noise.get_noise_3dv(point*freq+center)*scale-offset
	#print(noiseValue)
	var dist:float = 0.1
	var top:float = noise.get_noise_3dv((point*freq+center)+Vector3(dist,0,0))*scale-offset
	var bottom:float = noise.get_noise_3dv((point*freq+center)+Vector3(-dist,0,0))*scale-offset
	var left:float = noise.get_noise_3dv((point*freq+center)+Vector3(0,0,dist))*scale-offset
	var right:float = noise.get_noise_3dv((point*freq+center)+Vector3(0,0,-dist))*scale-offset

	return [noiseValue,[top,bottom,left,right]]

func updateEnabled(val):
	enabled = val
	emit_signal("changed")

func updateScale(val):
	scale = val
	emit_signal("changed")
	
func updateRoughness(val):
	roughness = val
	emit_signal("changed")

func updateCenter(val):
	center = val
	emit_signal("changed")

func updateOctaves(val):
	octaves = val
	emit_signal("changed")
	
func updateNoise(val):
	noiseSeed = val
	emit_signal("changed")
	
func updateOffset(val):
	offset = val
	emit_signal("changed")
	
func randSeed(_val):
	var time = OS.get_datetime()
	noiseSeed = hash(str(time.hour * time.minute * time.second * 168.541))
	property_list_changed_notify()
	emit_signal("changed")
