extends Sprite2D

@export var speed: float = 10 	
@export var limit_x: float = -400.0
@export var start_x: float = 800.0

func _process(delta: float) -> void:
	position.x -= speed * delta
	if position.x < limit_x:
		position.x = start_x
