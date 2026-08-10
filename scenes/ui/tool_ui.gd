extends Control

const TOOL_TEXTURES = {
Enum.Tool.AXE: preload("res://graphics/icons/axe.png"),
Enum.Tool.HOE: preload("res://graphics/icons/hoe.png"),
Enum.Tool.WATER: preload("res://graphics/icons/water.png"),
Enum.Tool.SWORD: preload("res://graphics/icons/sword.png"),
Enum.Tool.FISH: preload("res://graphics/icons/fish.png"),
Enum.Tool.SEED: preload("res://graphics/icons/wheat.png"),
}

var toolTextureScene = preload('res://scenes/ui/tool_ui_texture.tscn')


func _ready() -> void:
	$ToolContainer.hide()
	textureSetup(Enum.Tool.values(), TOOL_TEXTURES, $ToolContainer)


func textureSetup(enum_list: Array, textures: Dictionary, container: HBoxContainer):
	for enum_id in enum_list:
		var toolTexture = toolTextureScene.instantiate()
		toolTexture.setup(enum_id, textures[enum_id])
		container.add_child(toolTexture)
		

func reveal():
	$HideTimer.start()
	$ToolContainer.show()
	var target = get_parent().currentTool
	
	for texture in $ToolContainer.get_children():
		texture.highlight(target == texture.tool_enum)


func _on_hide_timer_timeout() -> void:
	$ToolContainer.hide()
