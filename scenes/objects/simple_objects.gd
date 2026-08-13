@tool
extends StaticBody2D

@export_range(0,3,1) var size: int:
	set(value):
		size = value
		$Sprite2D.frame_coords = Vector2i(size, style)
@export_enum('Bush','Rock') var style: int:
	set(value):
		style = value
		$Sprite2D.frame_coords = Vector2i(size, style)
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#rotate(5 * delta)
	#position.x -= 50 * delta
	pass

func _ready() -> void:
	$Sprite2D.frame_coords = Vector2i(size,style)
