extends StaticBody2D

const appleTex = preload("res://graphics/plants/apple.png")

#This code allows you to create Hit Points of the Tree now Idk why we wrote
# treeHP := 3
var treeHP := 3:
	#I think we using getter and setters method that's why
	#we used set(value)
	set(value):
		treeHP = value
		#print(value)
		#This is the kill state, if the tree hp is below 0, then say bye
		#to tree
		if treeHP < 0:
			#print("ded")
			$FlashTree.hide()
			$Stump.show()
			
			#We creating new collision shape
			var shape = RectangleShape2D.new()
			shape.size = Vector2(12,6)
			#Replace the collison shape and size
			$CollisionShape2D.shape = shape
			#I think we are moving the collison 
			$CollisionShape2D.position.y = 8
			
#ok so this function loads after tree is loaded, in human eyes, this is instant
#but in clanker's eyes it is milisecond difference
func _ready() -> void:
	createApples(3)

#This scene script is listening if the level.gd has sent the parameters or not
#if it did then it will print which tool was used used it will be either axe
#or sword others like seed, hoe and water will not work because they are
#sending parameter value.
func hit(tool: Enum.Tool):
	#We added if condition on tool, so only Axe is allowed to trigger flash, not sword
	if tool == Enum.Tool.AXE:
		$FlashTree.flash()
		getApple()
		#treeHP -= 1
		

#This function controls the number of apple, texture and location generated
func createApples(num: int):
	#I created variable appleMark, to get the children because there 
	#are multiple Marker2D nodes bellow AppleSpawnPos Node
	#The reason why we wrote duplicate is becaue we don't want to mess with children
	#or they will receive permanent damage so instead we will
	#create Virtual Epstein Island by writing duplicate(true)
	var appleMark = $AppleSpawnPos.get_children().duplicate(true)
	#We run through loops depending on num, if it's 3 then I will run 3 times
	for eye in num:
		#ok so we store the random value in the posMark from appleMark which
		#has total 7 Marker2D, so range from 0 to 6, yes appleMark.size() will
		#give you seven and don't want 8 total size, so real size is 7
		#remember pop_at will also remove one these chosen value from list
		#so no need to worry about duplication of position
		var posMark = appleMark.pop_at(randi_range(0, appleMark.size() -1))
		#so for my understanding the reason we used Sprite2D.new instead of 
		#instantiate() is because we don't have to create scene/class
		#this is the quick way to create sprite or add them
		var spirite = Sprite2D.new()
		#appleTex has the png of the apple so we are storing the damn apple
		spirite.texture = appleTex
		#we store these apple with in Apples node for some reason we storing texture
		$Apples.add_child(spirite)
		#We storing which Marker2D will be selected to show the apple if I'm not mistake
		spirite.position = posMark.position

#This function allows use to remove number of apples that was created by
#createApples function
func getApple():
	#Retrives the number of apples stored in Apples node
	if $Apples.get_children():
		#Removes random apples in the Apples node
		$Apples.get_children().pick_random().queue_free()
		print('Apple')
		
