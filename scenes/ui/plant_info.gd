extends PanelContainer

var target_plant: StaticBody2D

func setup(daPlant: StaticBody2D):
	target_plant = daPlant
	$HBoxContainer/VBoxContainer/Name.text = target_plant.res.plantName
	$HBoxContainer/Icon.texture = target_plant.res.icon
	
	$HBoxContainer/VBoxContainer/Growth.max_value = target_plant.res.hFrames
	$HBoxContainer/VBoxContainer/Decay.max_value = target_plant.res.deathMax
	
func _process(_delta: float) -> void:
	if is_instance_valid(target_plant):
		$HBoxContainer/VBoxContainer/Growth.value = target_plant.res.age
		$HBoxContainer/VBoxContainer/Decay.value = target_plant.res.deadTimer
	else:
		queue_free()
