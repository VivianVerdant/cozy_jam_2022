class_name ViewportText
extends Label

var position = Vector2(128.0,128.0)

func _init():
	text = "das whack"
	add_to_group("custom_ui")
	print("foo")

func _draw():
	draw_string(theme.font, position, text, Color( 1, 1, 1, 1 ), -1)
