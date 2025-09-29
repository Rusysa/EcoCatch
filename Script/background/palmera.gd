extends Node2D



func _ready() -> void:
	$TileMapLayer2/AnimatedSprite2D.play("palma")
	$TileMapLayer3/AnimatedSprite2D.play("palma")
	$TileMapLayer4/AnimatedSprite2D.play("default")
	$TileMapLayer5/AnimatedSprite2D.play("default")
	$TileMapLayer6/AnimatedSprite2D.play("default")
	$TileMapLayer7/AnimatedSprite2D.play("default")



func _process(delta: float) -> void:
	pass
