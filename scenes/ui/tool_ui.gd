extends Control

#We are relying on Dictionary that is much more efficient then manually adding 
#icon node.
const TOOL_TEXTURES = {
Enum.Tool.AXE: preload("res://graphics/icons/axe.png"),
Enum.Tool.HOE: preload("res://graphics/icons/hoe.png"),
Enum.Tool.WATER: preload("res://graphics/icons/water.png"),
Enum.Tool.SWORD: preload("res://graphics/icons/sword.png"),
Enum.Tool.FISH: preload("res://graphics/icons/fish.png"),
Enum.Tool.SEED: preload("res://graphics/icons/wheat.png"),}

#now We want to call a another smaller UI container which will allow us to add this
#icon to fit in
var toolTextureScene = preload('res://scenes/ui/tool_ui_texture.tscn')


#When game is started, this code will hide the UI
func _ready() -> void:
	$ToolContainer.hide()
	#ok so Enum_Tool.Values the idnex of the weapon, TOOL_TEXTURES gets the
	#the Icon shape and where to fit these icon with respect to their index int he container 
	#is the $ToolContainer
	textureSetup(Enum.Tool.values(), TOOL_TEXTURES, $ToolContainer)

#This is the main guy that takes decides what to take and then process as we said before:
	#ok so Enum_Tool.Values the idnex of the weapon, TOOL_TEXTURES gets the
	#the Icon shape and where to fit these icon with respect to their index int he container 
	#is the $ToolContainer
#So enum_list: Array stores Enum.Tool.values() sinces it is the array, textures: Dictionary 
#stores TOOL_TEXTURES and then finally container: HBoxContainer stores $ToolContainer
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
