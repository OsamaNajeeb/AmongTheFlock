extends Control

var tool_enum: Enum.Tool

func setup(newToolEnum: Enum.Tool, mainTexture: Texture2D):
	tool_enum = newToolEnum
	$TextureRect.texture = mainTexture
	
func highlight(selected: bool):
	var tween = create_tween()
	var targetSize = Vector2(20,20) if selected else Vector2(16,16)
	tween.tween_property($TextureRect, "custom_minimum_size", targetSize, 0.1)
