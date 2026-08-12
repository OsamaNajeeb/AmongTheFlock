extends Control

#We are relying on Dictionary that is much more efficient then manually adding 
#icon node.
const TOOL_TEXTURES = {
	Enum.Tool.AXE: preload("res://graphics/icons/axe.png"),
	Enum.Tool.HOE: preload("res://graphics/icons/hoe.png"),
	Enum.Tool.WATER: preload("res://graphics/icons/water.png"),
	Enum.Tool.SWORD: preload("res://graphics/icons/sword.png"),
	Enum.Tool.FISH: preload("res://graphics/icons/fish.png"),
	Enum.Tool.SEED: preload("res://graphics/icons/wheat.png"),
	}

const SEED_TEXTURES = {
	Enum.Seed.CORN: preload("res://graphics/icons/corn.png"),
	Enum.Seed.PUMPKIN: preload("res://graphics/icons/pumpkin.png"),
	Enum.Seed.TOMATO: preload("res://graphics/icons/tomato.png"),
	Enum.Seed.WHEAT: preload("res://graphics/icons/wheat.png")
	}

#now We want to call a another smaller UI container which will allow us to add this
#icon to fit in
var toolTextureScene = preload('res://scenes/ui/tool_ui_texture.tscn')


#When game is started, this code will hide the UI
func _ready() -> void:
	$ToolContainer.hide()
	$SeedContainer.hide()
	#ok so Enum_Tool.Values the idnex of the weapon, TOOL_TEXTURES gets the
	#the Icon shape and where to fit these icon with respect to their index int he container 
	#is the $ToolContainer
	textureSetup(Enum.Tool.values(), TOOL_TEXTURES, $ToolContainer)
	textureSetup(Enum.Seed.values(), SEED_TEXTURES, $SeedContainer)

#This is the main guy that takes decides what to take and then process as we said before:
	#ok so Enum_Tool.Values the idnex of the weapon, TOOL_TEXTURES gets the
	#the Icon shape and where to fit these icon with respect to their index int he container 
	#is the $ToolContainer
#So enum_list: Array stores Enum.Tool.values() sinces it is the array, textures: Dictionary 
#stores TOOL_TEXTURES and then finally container: HBoxContainer stores $ToolContainer
func textureSetup(enum_list: Array, textures: Dictionary, container: HBoxContainer):
	#You should remember that enum_list is in array format like {0,1,2,3,4,5}
	#like python we run loop in this array to read indivivual index within 
	#the array
	for enum_id in enum_list:
		#we are now calling the construction company to build toolTexture 
		#with toolTextureScene blueprint
		var toolTexture = toolTextureScene.instantiate()
		#telling construction company that specific enum_id(key) and and specific
		#textures[enum_id or exact key] is given to them to process
		toolTexture.setup(enum_id, textures[enum_id])
		#onces construction company has build an object now add it to main object
		container.add_child(toolTexture)

#This use to add timer and kool animation to the UI
func reveal(tool: bool):
	#once UI is poped up the timer start
	$HideTimer.start()
	#If you open the player.gd, you will see:
			#{currentTool = posmod(currentTool + int(dir), Enum.Tool.size()) as Enum.Tool
			#$ToolUi.reveal(true)
			#
		#if Input.is_action_just_pressed("seed_forward") and currentTool == Enum.Tool.SEED:
			#currentSeed = posmod(currentSeed + 1, Enum.Seed.size()) as Enum.Seed
			#$ToolUi.reveal(false)}
	#This code allows us to know that these code are connected and if the 
	#boolean is false then tool SeedContainer will not open like holding axe
	#or sword
	var currentContainer = $ToolContainer if tool else $SeedContainer
	currentContainer.show()
	var target = get_parent().currentTool if tool else get_parent().currentSeed
	$ToolContainer.hide()
	$SeedContainer.hide()
	currentContainer.show()
	
	for texture in currentContainer.get_children():
		texture.highlight(target == texture.tool_enum)
	


func _on_hide_timer_timeout() -> void:
	$ToolContainer.hide()
	$SeedContainer.hide()
