extends CharacterBody2D

#Direction of little fucker looking at
var direction: Vector2
#Movement seepd
var moveSpeed: float = 40.0
#This shit allows this beautiful lil guy stop near and tread towards you 24/7, good for meelee
#combat
var stopDistance: float = 10
#This is basically agro range, we lowered it for fun
var noticeDistance: float = 60 #orignal is 150
var blobHP := 3:
	set(value):
		blobHP = value
		if blobHP <= 0:
			#This function allows use to kill the blob and show kool animation
			death()

@onready var movestatemachine = $AnimationTree.get("parameters/MoveStateMachine/playback")

#It's simple we are declaring the Vector with null value which is 0,0
var knockBack: Vector2 = Vector2.ZERO
#Again declaring null value for Target/Entity ID
var targetPlayer: Node2D = null

#When Stupid game starts, this code allows Blob to attack entities in Player group
func _ready():
	targetPlayer = get_tree().get_first_node_in_group('Player')

#Heartbeat of game or something
func _physics_process(_delta: float) -> void:
	#So for my understanding, lerp is anotehr built in code, that allows entity to get
	#stun locked because it disables the moveSpeed (the movement speed of blob), forces
	#blob to reach Vector2.ZERO because it is the target speed, 0.1 is basically retardation
	#strength, how quick or slowly the blob will recover from stun locked, it's weird because
	#we don't use force and other shieet, if you then you have to use Rigid2D node but in
	#this it's not useful because Klanker (gemini) said so OK, DON'T ASK QUESTION
	knockBack = knockBack.lerp(Vector2.ZERO, 0.1)
	#Check if the player exist in this level or not, but since it exist, this condition is not true
	#by default 
	if targetPlayer != null:
		#global position is basically GPS of the every damn node and entities, for what I can
		#tell it is the most accurate and independent postion unlike .position builtin code.
		#distance_to is your classic Pythagorean distance o algo from player to blob.
		var distance = global_position.distance_to(targetPlayer.global_position)
		#in this condition as you remember once the velocity of blob is reduces till 10,
		#the stun locked is removed and normal AI start to run again.
		if knockBack.length() < 10.0:
			#Rememeber if noticeDistance is lesser and StopDistance is greater then the blue fucker
			#will stop/idle.
			if distance < noticeDistance and distance > stopDistance:
				direction = global_position.direction_to(targetPlayer.global_position)
				#After reason why we used this formula, remember direction_to uses built in 
				#Pythagorean like x (30/50) = 0.6 and y (40/50) = 0.8 but the problem is 
				#the blob will be slow, for now it's just mostly steering and barely movement
				#but with help of moveSpeed now it can move smoothly and steer
				velocity = direction * moveSpeed
			else:
				#as you remember if distance condition fails, then blob is idle/stop
				velocity = Vector2.ZERO
		else:
			#this is the final failed function that only works when you attack the blob
			#with sword
			velocity = knockBack
		move_and_slide()
		animate()

func animate():
	var directionAn = Vector2(round(direction.x),round(direction.y))
	$AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", directionAn)
	$AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", directionAn)
	if velocity != Vector2.ZERO:
		movestatemachine.travel('Walk')
	else:
		movestatemachine.travel('Idle')
	
func death():
	moveSpeed = 0
	$AnimationPlayer.current_animation = 'DEATH'

func hit(tool: Enum.Tool):
	if tool == Enum.Tool.SWORD:
		if targetPlayer != null:
			var pushDirection = targetPlayer.global_position.direction_to(global_position)
			#This is the main force of the knockback, this is the mastermind of all real world problems
			knockBack = pushDirection * 200.0
			$FlashSprite2D.flash()
			#blobHP -= 1
