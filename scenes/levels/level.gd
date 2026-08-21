extends Node2D

var debugHitPos: Vector2
var debugHitRadius: float = 0.0
var showDebugHit: bool = false

@onready var daytransitionMaterial = $Overlay/CanvasLayer/DayTransitionLayer.material
#So we added Day & Night effect in our game with help of gradient
#if you Level node, you can see the gradient and make some adjustment
@export var daytime_color: Gradient

#We used preload because we need to store the plant in memory so that it
#doesn't drop fps when we need to plant see as the Game will try to load
#in every action
var plantScene = preload("res://scenes/objects/plant.tscn")

#For my understanding we store the coordination in the Array, why because when
#we plant a seed, someone has to remember if we plant the seed and where exactly
#did we plant it so that the game doesn't turn into clusterfuck
var usedCells: Array[Vector2i]

#This code allows us to unlock most of the features and tracking parameters of 
#your current player, like where he is at and wtf is he doing and that's all
#before game is started
@onready var player: CharacterBody2D = $Objects/Player

#This is debugging code, we will use it as aim or where you little fucker 
#is looking at or something
func _physics_process(_delta: float) -> void:
	var pos = player.position + player.lastDirection * 16 + Vector2(0,4)
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE), int(pos.y / Data.TILE_SIZE))
	#We used this code because Idk Godot isn't perfect or something, math issue
	#where if you move to the left of the point of origin then everything
	#becomes complete dogshit nonsense, so just to fix this we had to right this code
	#it's like square root stuff if the value is negative it becomes positive
	#so that you will get the value without your dumb calculator going haywire
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	#ok this code just remove the previous tile because again we don't have to 
	#cluster fuck the game it's going to create trails of roof if you don't add this
	$Layers/DebugLayer.clear()
	$Layers/DebugLayer.set_cell(grid_coord,0, Vector2i(1,3))
	
	#This is part of the gradient, so in order to change the gradient 
	#it has read from 0 to 1 or 1 to 0 so that it is consistent.
	var daytime_point = 1 - ($Timers/DayTime.time_left / $Timers/DayTime.wait_time)
	#we used sample instead of get_color because get color needs specific color
	#where as sample just need 0 till 1, and it's more dynamic and it is
	#suitable for our gradient guy
	var color = daytime_color.sample(daytime_point)
	#We then Update the color of the DayTimeColor with this gradient
	$Overlay/DayTimeColor.color = color
	
	#if the tab is pressed then call levelReset(), CTRL + LC on 
	#levelReset()
	if Input.is_action_just_pressed("day_change"):
		levelReset()
		

#func _draw():
	#if showDebugHit:
		#draw_circle(debugHitPos, debugHitRadius, Color(1,0,0,0.8))

#Enum.Tool is basically numbers, in enums.gd file, axe is 0, and seed is 5
func _on_player_tool_use(tool: Enum.Tool, pos: Vector2) -> void:
	#The reason we are using Vector2i again we need precise coordination no decimal no funny numbers only
	# 1,2 ...54, and Vector2 simply converts them into float/decimals thats why we use Vector2i
	#Data.Tile_Size is 16, 16 bit basically converting them into proper coordination, you can write 
	#16 instead of Data.TILE_SIZE as well becasue it doesn't matter cuz this is just fancy / "Efficient" 
	#programming shit that nophono doesn't care
	var grid_coord: Vector2i = Vector2i(int(pos.x / Data.TILE_SIZE), int(pos.y / Data.TILE_SIZE))
	grid_coord.x += -1 if pos.x < 0 else 0
	grid_coord.y += -1 if pos.y < 0 else 0
	#Just make it simpler we used get_used_cells, if this Layer is used on exact coordinates 
	#or not.
	var has_soil = grid_coord in $Layers/SoilLayer.get_used_cells()
	match tool:
		Enum.Tool.HOE:
			#This part of the code is VERY IMPORTANT TO UNDERSTAND SAAAR
			#ok For my understanding this part of the code just calls the
			#the physics engine for some reason
			var spaceState = get_world_2d().direct_space_state
			print(spaceState)
			#This is basically the area of what player is looking at,
			#this is will make sure that debugger tile will check if the 
			#object's area2D collision is under the debugger tile or not
			#which is more accurate and better than that fucking radar ping
			var recShape = RectangleShape2D.new()
			recShape.size = Vector2(16,16)
			#This is basically where the Godot takes the ground, define wtf
			#these are, does it contain simple grass or it has some obstacles
			var query = PhysicsShapeQueryParameters2D.new()
			query.shape = recShape
			var tileCentre = Vector2(grid_coord) * Data.TILE_SIZE + Vector2(8, 8)
			query.transform = Transform2D(0, tileCentre)
			#This line of code allows Godot to ignore Player Collision
			query.exclude = [player.get_rid()]
			query.collide_with_areas = true
			#This part is very important so if it detects the obstacles it 
			#give you so many fucking ID and node in details, if there is 
			#no obstacles then it gives you null
			var hitResults = spaceState.intersect_shape(query)
			##print(hitResults)
			var obstacles = hitResults.size() > 0
			
			#var obstacles = false
			#for object in get_tree().get_nodes_in_group('Objects'):
				#if object.position.distance_to(pos) < 25:
					#obstacles = true
					#break
			#for object in get_tree().get_nodes_in_group('SObjects'):
				#if object.position.distance_to(pos) < 16:
					#obstacles = true
					#break
			if obstacles == false:
				var cell = $Layers/GrassLayer.get_cell_tile_data(grid_coord) as TileData
				if cell and cell.get_custom_data('Farmable'):
					#Ok I know we have to call SoilLayer to apply on GrassLayer if I'm not mistaken.
					#set_cells_terrain_connect() is the main guy that let us set terrain on existing terrain
					#we have grid vector or our coordination, terrain SET and then terrain 
					$Layers/SoilLayer.set_cells_terrain_connect([grid_coord],0,0)
			
		Enum.Tool.WATER:
			if has_soil:
				#If it does exist then set_cell will look for coordinate, then it looks
				#for tileset ID which is zero because there only 1 TileSource in
				#this node, and then it looks for which tile do we have to set, 
				#so we gave it the random tile set from 0 to 2 which means 3 column 
				#and then there only row so it's zero 
				$Layers/WetSoilLayer.set_cell(grid_coord,0,Vector2i(randi_range(0,2),0))
		
		Enum.Tool.FISH:
			if not grid_coord in $Layers/GrassLayer.get_used_cells():
				print("Fishing")
			else:
				print("Not Fishing")
		
		Enum.Tool.SEED:
			if has_soil and grid_coord not in usedCells:
				var plantRes = PlantResource.new()
				plantRes.setup($Objects/Player.currentSeed)
				#instantiate() is basically constructor like scene which is
				#which is basically class, we have to build the class/scene/blueprint
				#with help of constructor which is instantiate the construction company,
				#the building we finished building is plant
				var plant = plantScene.instantiate()
				plant.setup(grid_coord,$Objects, plantRes)
				#Append stores value at the end of the array, push_back pops the last
				#value in the array, whereas push_front stores value in first
				#index but I don't know if there any stupid built in command
				#that removes first index value in the array
				usedCells.append(grid_coord)
				plant.tree_exited.connect(func(): usedCells.erase(grid_coord))
				
			#CODE BELOW REMOVED BUT IT'S NOT BAD
			#the code below does same thing as before but it is less random that's all	
			#if $Layers/SoilLayer.get_cell_source_id(grid_coord) != -1:
				#$Layers/WetSoilLayer.set_cells_terrain_connect([grid_coord],0,0)
			#else:
				#print("Failed")
		
		#In this scene, we check if the player is holding sword or axe.
		Enum.Tool.AXE, Enum.Tool.SWORD:
			$Layers/HitMarker.global_position = pos
			$Layers/HitMarker.radius = 17
			$Layers/HitMarker.queue_redraw()
			#In this part for my understanding is that, there anyother way 
			#to tag or add values in complex array instead of relying with 
			#One variable, get_tree gets the whole tree, and check if this tag name
			#Objects is in the tree.
			for object in get_tree().get_nodes_in_group('Objects'):
				#This is basically straight line range of you character 
				#if the range is within then it means your character can 
				#interct with tree only with sword and axe, but I feel like
				#it's completely meelee, I can still hit the tree in distance
				if object.position.distance_to(pos) < 17:
					#We send the parameters to the custom build scene called
					#tree to make some adjustment
					object.hit(tool)
			
			await get_tree().create_timer(0.3).timeout
			$Layers/HitMarker.radius = 0.0
			$Layers/HitMarker.queue_redraw()
			
#For now we are not focusing on KOOOL transition because I didn't ask
func dayRestart():
	var tween = create_tween()
	tween.tween_property(daytransitionMaterial, "shader_parameter/progress", 1.0, 1.0)
	tween.tween_interval(0.5)
	tween.tween_callback(levelReset)
	tween.tween_property(daytransitionMaterial, "shader_parameter/progress", 0.0, 1.0)

#This function reset the gradient color by resetting the time.
func levelReset():
	
	#This for loop checks if these node has group node called Plants
	for plant in get_tree().get_nodes_in_group('Plants'):
		
		#Once found then it, ok this code down is kinda complex for my 1 IQ brain so here is the
		#Code snippit that Gemini has given which is helpful for my 1 kb RAM brain
		
		## Grab the list of all the wet tiles
		##var wet_tiles_list = $Layers/WetSoilLayer.get_used_cells()
		## Check if this specific plant's coordinate is inside that list
		##if plant.coord in wet_tiles_list:
			## If YES, tell the plant it was watered
		   ##plant.grow(true)
		##else:
			## If NO, tell the plant it was NOT watered
			##plant.grow(false)
			
		plant.grow(plant.coord in $Layers/WetSoilLayer.get_used_cells())
	$Layers/WetSoilLayer.clear()
	
	$Timers/DayTime.start()
	#This is super heckin important saar, so for my understanding, this line of code uses
	#this new concept called duck typing which means if that little shit walks like duck, quacks
	#like duck and shit like duck then it is duck for some reason
	#So first we get tree which means every FUCKING NODES in the on your
	#left screen if you open SCENE section next to Import, then it looks for
	#nodes which in this case the Objects, once we done that
	#it ask every damn gd in that node if it has function called 'reset' or not
	#once it finds it then it execute it.
	for object in get_tree().get_nodes_in_group('Objects'):
		if object.has_method('reset'):
			object.reset()
