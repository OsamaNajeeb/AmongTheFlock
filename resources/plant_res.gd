class_name PlantResource extends Resource

#Just to make the code flexible, we are using dictionary to handle most
#of the texture of the plant, value of dictionary stored in data.gd and the 
#static ID stored in enums.gd
@export var texture: Texture2D
@export var growSpeed : float = 1.0
@export var hFrames: int = 3
@export var deathMax: int = 3
@export var plantName: String
@export var icon: Texture2D
 
var age: float
var deadTimer : int
var dead: bool:
	set(value):
		dead = value
		emit_changed()

func setup(seedEnum: Enum.Seed):
	texture = load(Data.PLANT_DATA[seedEnum]['texture'])
	growSpeed = Data.PLANT_DATA[seedEnum]['grow_speed']
	hFrames = Data.PLANT_DATA[seedEnum]['h_frames']
	deathMax = Data.PLANT_DATA[seedEnum]['death_max']
	icon = load(Data.PLANT_DATA[seedEnum]['icon_texture'])
	plantName = Data.PLANT_DATA[seedEnum]['name']

func grow(sprite: Sprite2D):
	age = min(age + growSpeed, hFrames)
	sprite.frame = int(age)
	deadTimer = 0

func decay(plant: StaticBody2D):
	deadTimer += 1
	#print(deadTimer)
	if deadTimer >= deathMax:
		deadTimer = 0
		emit_changed()
		plant.queue_free()

#Maybe ONE FUCKING DAY I will understand why we use return because
#no matter how many times these AI clanker explain, the plane just crashes
#on my head, doesn't even fly over the head bruh
func harvastable() -> bool:
	return age >= hFrames
