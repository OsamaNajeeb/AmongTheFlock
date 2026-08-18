extends CharacterBody2D
#Ok so this calling vector to move in 2D
var direction: Vector2

#The difference between var direction and lastDirection is that direction is current direction which
#will be removed if character moves but lastDirection is saved direction of the player
var lastDirection: Vector2
#so this the speed of direction the character is moving by default it's 50
var speed = 125
#To avoid that stupid animation and movement that looks goofy, we are adding delay in movement
var canMove: bool = true

#Ok so my understand that these code run in sequence from top to bottom like any other, so 
#this line code tells Machine/Godot, you don't have to call this code right now but until this
#character is built or something then call this this code, so on ready is the reminder.
@onready var movestatemachine = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var toolStateMachine = $Animation/AnimationTree.get("parameters/ToolStateMachine/playback")

#So This code looks through Enums.gd and get values that are in elements, so Axe is 0, and Hoe is 1...
var currentTool : Enum.Tool
var currentSeed : Enum.Seed

#So my understanding is that this signal is loose function, a simple function is too strict, where did
#sound came from, where did parameters came from, all this matters whereas signal is like chillbro
signal tool_use(tool: Enum.Tool, pos: Vector2)

#This is the heart beat or tick
func _physics_process(_delta: float) -> void:
	#This Condition uses _on_animation_tree_animation_started and _on_animation_tree_animation_finished
	#Built in function if the animation is started it will turn canMove = false, if finished then it turns
	#True, this way the character can stand and finish the animation which would make less janky game
	#and player wouldn't exploit collison
	if canMove:
		#This initiate movement, direction of movement and speed
		move()
		#This calls the type of animation
		animate()
		#This calls the oneshot function
		getbasicinput()
		
	if direction:
		lastDirection = direction
	

#This code is action function, action can be done limited frames not continous
func getbasicinput():
	#Ok so tool_forward and tool_backward is input map which is Q(tool_backward) and E(tool_forward)
	#so Input os listening these keys if they got triggered or not
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		#get_axis assigns the two value as -1.0 and +1.0
		var dir = Input.get_axis("tool_backward","tool_forward")
		#So whenever user press Q and E, it calls dir which see which button was press so if 
		#Q was pressed which was tool_backward then it is -1 which was done by get_axis and then
		#-1 is then converted to int as you remember get_axis uses float
		#ok so Posmod which is postive mod, takes value from (currentTool + int(dir)) let's assume
		#it's -1, converts them into positive after looking at Enum.Tool.size which is 6 max.
		#It then converts -1 to 5 because it's like element it start from 0 to 5, this way
		#Your code works smoothly
		currentTool = posmod(currentTool + int(dir), Enum.Tool.size()) as Enum.Tool
		$ToolUi.reveal(true)
		
	if Input.is_action_just_pressed("seed_forward") and currentTool == Enum.Tool.SEED:
		currentSeed = posmod(currentSeed + 1, Enum.Seed.size()) as Enum.Seed
		$ToolUi.reveal(false)
	
	#This condition uses built in code to listen if the action inside input map 
	#is pressed or not
	if Input.is_action_just_pressed("action"):
		#So computer knows that these index of enums in Data, so to avoid typos when relying on values 
		#just like SQL, the enum works as human readable words and computer safe logic
		toolStateMachine.travel(Data.TOOL_STATE_ANIMATIONS[currentTool])
		#print(Data.TOOL_STATE_ANIMATIONS[currentTool])
		#print(currentTool)
		
		#Once pressed, then it calls the ToolOneShot Oneshot manager
		$Animation/AnimationTree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		

func move():
	#Negative X (Left), Postive X (Right), Negative Y (Up) and Positive Y (Down)
	direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed
	move_and_slide()
	
func animate():
	if direction:
		#ok I think I understand now, so if you open AnimationTree tab and Path is Root > MoveStateMachine
		#You can see Start is connected to Idle first and Walk & Idle is going back and forth,
		#It is basically subway or destinations, so the animation has to go throw subway depending
		#on input keys
		movestatemachine.travel('Walk')
		#This rounding up makes sure that every heart beat of engine, if I'm not wrong, if you
		#press two button at the same time, it doesn't go 0 to 1, instead it works like this,
		#(x = 0.1, y = 0.1), (x=0.3, y=0.3) until it reaches (x = 1, y = 1). That's how it works.
		#if I'm correct.
		var directionAn = Vector2(round(direction.x),round(direction.y))
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", directionAn)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", directionAn)
		#So this is Player.gd script, and dictionary is in data.gd which has name of the
		#dictionary called TOOL_STATE_ANIMATIONS
		
		#Ok this uses dictionary which means in Data file, there is:
			#const TOOL_STATE_ANIMATIONS = {
				#Enum.Tool.HOE(Key): 'Hoe'(Value),
				#Enum.Tool.AXE(Key): 'Axe'(Value),.....}
		#So Values is remember takes the values such as Hoe, Axe from keys which
		#are Enum.Tool.HOE & Enum.Tool.AXE keys
		for animation in Data.TOOL_STATE_ANIMATIONS.values():
			var animationName : String = "parameters/ToolStateMachine/"+animation+"/blend_position"
			$Animation/AnimationTree.set(animationName, directionAn)
	else:
		movestatemachine.travel('Idle')


func tool_use_emit():
	#I understand that emit listens if any action has been taken, and store numbers
	#position is the built in code that checks the position of the character.
	#Also the reason we put tool_use here it's because if you open Animation, see the frames,
	#there is function row, it has tool_use_emit func, this we don't have to add stupid delay / timer
	#to deploy or apply action, you easily adjust through frames, which ain't bad idea.
	if currentTool == Enum.Tool.SWORD or currentTool == Enum.Tool.AXE:
		tool_use.emit(currentTool, position + lastDirection * 8 + Vector2(0,4))
	else:
		tool_use.emit(currentTool, position + lastDirection * 16 + Vector2(0,4))
	#if currentTool == Enum.Tool.FISH:
		#tool_use.emit(currentTool, position + lastDirection * 32 + Vector2(0,4))
	#else:
		#tool_use.emit(currentTool, position + lastDirection * 16 + Vector2(0,4))


func _on_animation_tree_animation_started(_anim_name: StringName) -> void:
	canMove = false


func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	canMove = true
