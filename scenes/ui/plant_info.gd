extends PanelContainer

var targetPlant: StaticBody2D

func setup(daPlant: StaticBody2D):
	targetPlant = daPlant
	$HBoxContainer/VBoxContainer/Name.text = targetPlant.res.plantName
	$HBoxContainer/Icon.texture = targetPlant.res.icon
	
	$HBoxContainer/VBoxContainer/Growth.max_value = targetPlant.res.hFrames
	$HBoxContainer/VBoxContainer/Decay.max_value = targetPlant.res.deathMax
	update()

func update():
	$HBoxContainer/VBoxContainer/Growth.value = targetPlant.res.age
	$HBoxContainer/VBoxContainer/Decay.value = targetPlant.res.deadTimer

func _process(_delta: float) -> void:
	if not is_instance_valid(targetPlant):
		queue_free()
