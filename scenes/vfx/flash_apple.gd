extends Sprite2D

#This code allows use to mess with built in shader system of the godot, 
#most of the shading color, opacity and others are done in Shader Editor
#but make it more interactive can be done through here,
#so we added duration of object turning white and then turning to original color
#in the span of 0.4 sec
#Update: We added callback because we can add built in function in the parameter
#to make the plant dissappear such as queue_free()
func flash(startDuration: float = 0.2, endDuration: float = 0.2, callback: Callable = Callable()):
	#Just like adobe animate, this create_tween has almost same feature.
	var tween = create_tween()
	#so first we pinpoint, is it material, texture or visility, but for now it's
	#Material, then we have give the path to FloatParameter which named as Progress
	#then we set to 1 max color in the span of 0.2 sec (startDuaration)
	tween.tween_property(material, 'shader_parameter/Progress', 1.0, startDuration)
	#We added this code to make sure if the built in function was added or not
	#Maybe it's like safe trigger idk
	if callback.is_valid():
		tween.tween_callback(callback)
	#Once it reaches 1 in the span of 0.2 sec then it has return to 0 in the span
	#of 0.2 sec (endDuration)
	tween.tween_property(material, 'shader_parameter/Progress', 0.0, endDuration)
