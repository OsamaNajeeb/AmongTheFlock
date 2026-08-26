extends Control

func add(child: PanelContainer):
	$MarginContainer/ScrollContainer/VBoxContainer.add_child(child)

func updateAll():
	for plantInfo in $MarginContainer/ScrollContainer/VBoxContainer.get_children():
		plantInfo.update()
