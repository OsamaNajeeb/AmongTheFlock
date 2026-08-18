extends StaticBody2D

var coord: Vector2i
@export var res: PlantResource

#In this function for my understanding we get the coordinates, mess around with 
#coordinates until it becomes pixel, and make sure that whole object visually is
#added and can be interactive as well.
func setup(gridCoord: Vector2i, parent: Node2D):
	position = gridCoord * Data.TILE_SIZE + Vector2i(8,5)
	#print("Pixel" + str(position) + " Coordinates"  + str(gridCoord))
	parent.add_child(self)
	coord = gridCoord
	$Sprite2D.texture = res.texture
	
func grow(watered: bool):
	if watered:
		res.grow($Sprite2D)
