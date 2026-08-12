extends Control

var tool_enum: Enum.Tool

#Construction Company now recieved enum_id and textures[enum_id]
#Construction Company will now build the object
func setup(newToolEnum: Enum.Tool, mainTexture: Texture2D):
	#For my understanding this is to make sure the right enum_id and png
	#is going outside
	tool_enum = newToolEnum
	$TextureRect.texture = mainTexture

#This is basically animation 
func highlight(selected: bool):
	var tween = create_tween()
	var targetSize = Vector2(20,20) if selected else Vector2(16,16)
	tween.tween_property($TextureRect, "custom_minimum_size", targetSize, 0.1)
