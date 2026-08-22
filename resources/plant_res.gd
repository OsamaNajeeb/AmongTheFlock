class_name PlantResource extends Resource

#Just to make the code flexible, we are using dictionary to handle most
#of the texture of the plant, value of dictionary stored in data.gd and the 
#static ID stored in enums.gd
@export var texture: Texture2D
@export var growSpeed : float = 1.0
@export var hFrames: int = 3
@export var deathMax: int = 3
 
var age: float
var deadTimer : int

func setup(seedEnum: Enum.Seed):
	texture = load(Data.PLANT_DATA[seedEnum]['texture'])
	growSpeed = Data.PLANT_DATA[seedEnum]['grow_speed']
	hFrames = Data.PLANT_DATA[seedEnum]['h_frames']
	deathMax = Data.PLANT_DATA[seedEnum]['death_max']

func grow(sprite: Sprite2D):
	age = min(age + growSpeed, hFrames)
	sprite.frame = int(age)
	deadTimer = 0

func decay(plant: StaticBody2D):
	deadTimer += 1
	print(deadTimer)
	if deadTimer >= deathMax:
		deadTimer = 0
		plant.queue_free()
