extends CharacterBody2D

var direction: Vector2
var moveSpeed: float = 40.0
var stopDistance: float = 10.0
var noticeDistance: float = 20 #orignal is 150
var blobHP := 3:
	set(value):
		blobHP = value
		#print(value)
		#This is the kill state, if the tree hp is below 0, then say bye
		#to tree
		if blobHP <= 0:
			#print("ded")
			death()
			
var knockBack: Vector2 = Vector2.ZERO
var targetPlayer: Node2D = null

func _ready():
	targetPlayer = get_tree().get_first_node_in_group('Player')
	
func _physics_process(_delta: float) -> void:
	knockBack = knockBack.lerp(Vector2.ZERO, 0.1)
	if targetPlayer != null:
		var distance = global_position.distance_to(targetPlayer.global_position)
		if knockBack.length() < 10.0:
			if distance < noticeDistance and distance > stopDistance:
				direction = global_position.direction_to(targetPlayer.global_position)
				velocity = direction * moveSpeed
			else:
				direction = Vector2.ZERO
				velocity = Vector2.ZERO
		else:
			velocity = knockBack
		move_and_slide()

func death():
	moveSpeed = 0
	$AnimationPlayer.current_animation = 'DEATH'

func hit(tool: Enum.Tool):
	if tool == Enum.Tool.SWORD:
		if targetPlayer != null:
			var pushDirection = targetPlayer.global_position.direction_to(global_position)
			knockBack = pushDirection * 200.0
			$FlashSprite2D.flash()
			blobHP -= 1
