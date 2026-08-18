class_name  PlantResource extends Resource

@export var texture: Texture2D
@export var growSpeed := 1
 
var age: float
var deadTimer : int

func grow(sprite: Sprite2D):
	age = min(age + growSpeed, sprite.hframes -1)
	sprite.frame = int(age)
	deadTimer = 0

func decay(plant: StaticBody2D):
	deadTimer += 1
	print(deadTimer)
	if deadTimer >= 3:
		deadTimer = 0
		plant.queue_free()
