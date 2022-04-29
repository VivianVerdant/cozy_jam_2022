class_name terrain_mesh
extends MeshInstance

var arrays = []

var surface_mesh = ArrayMesh.new()

var normal_array = PoolVector3Array()
var vertex_array = PoolVector3Array()
var uv_array = PoolVector2Array()
var index_array = PoolIntArray()
var tangent_array = PoolRealArray()
var color_array = PoolColorArray()

var chunk_settings

func generate_mesh(settings,origin,noise_layers,features):
	#print("generating mesh")
	chunk_settings = settings
	
	arrays.resize(Mesh.ARRAY_MAX)
	
	for y in chunk_settings.res:
		for x in chunk_settings.res:
			var i = x + (y * chunk_settings.res)
			var x_size = chunk_settings.size/(chunk_settings.res-1)
			var y_size = chunk_settings.size/(chunk_settings.res-1)
			
			var V1 = Vector3(x*x_size,0,y*y_size)

			var noise = 0
			for noise_layer in noise_layers:
				noise += noise_layer.evaluate(V1+origin)
			V1.y += noise
			
			if features.size() > 0 :
				for feature in features:
					pass
					#var a = Vector2(feature.translation.x,feature.translation.z)
					#var b = Vector2(V1.x+origin.x,V1.z+origin.z)
					#var dist = a.distance_to(b)
					#print(dist)
					#V1.y -= ease
			
			vertex_array.push_back(V1)
			uv_array.push_back(Vector2(x as float/(chunk_settings.res as float - 1),y as float/(chunk_settings.res as float - 1)))
			
			var e = 1.0
			var normal = Vector3(0.0,e,0.0)
			var VN1 = V1 - Vector3(e,0.0,0.0)
			for noise_layer in noise_layers:
				normal.x += noise_layer.evaluate(VN1+origin)
			var VN2 = V1 + Vector3(e,0.0,0.0)
			for noise_layer in noise_layers:
				normal.x -= noise_layer.evaluate(VN2+origin)
			var VN3 = V1 - Vector3(0.0,0.0,e)
			for noise_layer in noise_layers:
				normal.z += noise_layer.evaluate(VN3+origin)
			var VN4 = V1 + Vector3(0.0,0.0,e)
			for noise_layer in noise_layers:
				normal.z -= noise_layer.evaluate(VN4+origin)
			normal = normal.normalized()
			normal_array.push_back(normal)
			#var tangent = Plane(V1,VN1,VN3).normalized()
			tangent_array.push_back(0)
			tangent_array.push_back(0)
			tangent_array.push_back(1)
			tangent_array.push_back(-1)
			
			color_array.push_back(Color(noise,noise,noise))
#			normal_array.push_back(Vector3(0.0,e,0.0).normalized())
			
			if x < chunk_settings.res-1 and y < chunk_settings.res-1:
				index_array.append(i)
				index_array.append(i + chunk_settings.res + 1)
				index_array.append(i + chunk_settings.res)
				
				index_array.append(i)
				index_array.append(i + 1)
				index_array.append(i + chunk_settings.res + 1)
			
	arrays[Mesh.ARRAY_VERTEX] = vertex_array
	arrays[Mesh.ARRAY_TEX_UV] = uv_array
	arrays[Mesh.ARRAY_NORMAL] = normal_array
	arrays[Mesh.ARRAY_TANGENT] = tangent_array
	arrays[Mesh.ARRAY_INDEX] = index_array
	arrays[Mesh.ARRAY_COLOR] = color_array
	#print(tangent_array)
	
	surface_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
	
#	var st = SurfaceTool.new()
#	st.create_from(surface_mesh,0)
#	st.generate_tangents()
	
	mesh = surface_mesh
	
	create_trimesh_collision()
	
	#create_convex_collision()
