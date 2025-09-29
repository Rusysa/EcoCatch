extends Area2D

# Exportamos el tipo para poder definirlo en el editor para cada objeto (vidrio, plastico, lata)
@export var object_type: String = "lata"
var fall_speed: float = 100.0
var is_grounded: bool = false
@onready var collision_shape = $CollisionShape2D
@onready var collision_timer = $CollisionTimer
func _physics_process(delta):
	position.y += fall_speed * delta

# Esta función será llamada desde el script del suelo
func stop_falling():
	set_physics_process(false)
	
# Esta función desactiva la colisión y activa el temporizador
func disable_collision_briefly():
	collision_shape.disabled = true
	collision_timer.start()

# Cuando el temporizador termina, la colisión se reactiva
func _on_collision_timer_timeout():
	collision_shape.disabled = false
