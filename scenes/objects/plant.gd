extends StaticBody2D

var coord: Vector2i
@export var res: PlantResource

#In this function for my understanding we get the coordinates, mess around with 
#coordinates until it becomes pixel, and make sure that whole object visually is
#added and can be interactive as well.
func setup(gridCoord: Vector2i, parent: Node2D, newResource: PlantResource):
	position = gridCoord * Data.TILE_SIZE + Vector2i(8,5)
	#print("Pixel" + str(position) + " Coordinates"  + str(gridCoord))
	parent.add_child(self)
	
	coord = gridCoord
	res = newResource
	$FlashApple.texture = res.texture
	
func grow(watered: bool):
	if watered:
		res.grow($FlashApple)
	else:
		res.decay(self)

#So we used Signals>Connecting the Area2D with Plant.gd.
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if res.harvastable():
			$FlashApple.flash(0.2, 0.4, queue_free)
			#death.emit(coord)
			#res.dead = true
