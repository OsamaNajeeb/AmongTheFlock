class_name  PlantResource extends Resource

@export var texture: Texture2D
@export var growSpeed := 1

var age: float

func grow(sprite: Sprite2D):
	age += min(age + growSpeed, sprite.hframes -1)
	sprite.frame = int(age)
