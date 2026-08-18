@tool
extends StaticBody2D

@export var randomBool : bool = true

@export_range(0,3,1) var size: int:
	set(value):
		size = value
		# SAFETY CHECK: Only talk to the Sprite if it exists!
		if is_node_ready():
			$Sprite2D.frame_coords = Vector2i(size, style)
			
@export_enum('Bush','Rock') var style: int:
	set(value):
		style = value
		# SAFETY CHECK: Only talk to the Sprite if it exists!
		if is_node_ready():
			$Sprite2D.frame_coords = Vector2i(size, style)
		
@export_tool_button('Randomize Button', "Callable") var  randomzier = randomize


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#rotate(5 * delta)
	#position.x -= 50 * delta
	pass

func _ready() -> void:
	if randomBool == true:
		size = randi_range(0,3)
		style = randi_range(0,1)
		
	$Sprite2D.frame_coords = Vector2i(size,style)
	$CollisionShape2D.disabled = size < 2
	z_index = -1 if size < 2 else 0
	
func randomize():
	size = randi_range(0,3)
	style = randi_range(0,1)
	
	# You should also add the safety check to your custom Randomize button 
	# just in case you click it at a weird time in the editor!
	if is_node_ready():
		$Sprite2D.frame_coords = Vector2i(size,style)
