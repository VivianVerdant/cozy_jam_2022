tool
extends EditorScript

func _run():
	print(get_scene())

func get_scene_root():
	return get_scene()
	
func get_interface():
	return get_editor_interface()
