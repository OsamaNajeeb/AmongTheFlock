extends Node2D

var radius: float = 0.0

func _draw():
	if radius > 0:
		draw_circle(Vector2.ZERO, radius, Color(1, 0, 0, 0.8))
