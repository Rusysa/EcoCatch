extends Node2D
@export var object_scenes: Array[PackedScene] = []

var score: int = 0
var high_score: int = 0

@export var grounded_objects_count: int = 0
var base_fall_speed: float = 100
var time_elapsed: float = 0.0

@onready var spawn_timer = $SpawnTimer
@onready var player = $Main_character
@onready var spawn_path = $Path2D # Usaremos un Path2D para definir el área de spawn
@onready var spawn_location = $Path2D/PathFollow2D
@onready var ui = $UI
@onready var music_player = $Backgroundmusic
@onready var notification_label = $CanvasLayer/NotificationLabel 

func _ready():
	grounded_objects_count = 0
	$Backgroundmusic.play()

	SignalManager.on_score_updated.connect(_on_score_updated)
	SignalManager.on_object_grounded.connect(_on_object_grounded)
	SignalManager.on_grounded_object_collected.connect(_on_grounded_object_collected)

	
	load_high_score()
	ui.update_score(score)
	ui.update_high_score(high_score)
	ui.update_grounded_objects(grounded_objects_count)
	spawn_timer.start()

func show_notification(message: String):

	notification_label.text = message
	notification_label.modulate.a = 0.0 # Nos aseguramos que inicie transparente

	var tween = create_tween()
	tween.tween_property(notification_label, "modulate:a", 1.0, 0.5)
	tween.tween_interval(1.5)
	tween.tween_property(notification_label, "modulate:a", 0.0, 0.5)

func fade_out_music(duration: float = 2.0):

	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80, duration)

	await tween.finished
	music_player.stop()

func _process(delta):
	time_elapsed += delta
	#La dificultad aumenta cada 15 segundos de 25 en 25
	if fmod(time_elapsed, 15) < delta:
		base_fall_speed += 25.0
		spawn_timer.wait_time = max(0.5, spawn_timer.wait_time * 0.9) 
		print("¡Velocidad aumentada! Nueva velocidad base: ", base_fall_speed)
		show_notification("¡Velocidad Aumentada!")




func _on_spawn_timer_timeout():
	if object_scenes.is_empty(): return

	# Elegimos un objeto al azar
	var random_object_scene = object_scenes.pick_random()
	var new_object = random_object_scene.instantiate()

	# Posición de spawn aleatoria
	spawn_location.progress_ratio = randf()
	new_object.position = spawn_location.position
	
	# Asignamos la velocidad de caída actual
	new_object.fall_speed = base_fall_speed

	add_child(new_object)

# Esta función se conecta a la señal area_entered del Suelo (Ground)
		
func _on_ground_area_entered(area):
	if get_node("Main_character").held_object == area:
		return
	if area.is_in_group("object"):

		if not area.is_grounded:
			area.set_physics_process(false)
			area.is_grounded = true
			
			grounded_objects_count += 1
			print("SUMA: '", area.name, "' ha tocado el suelo. Total ahora: ", grounded_objects_count)
			ui.update_grounded_objects(grounded_objects_count)
		
			#print("Objeto ha tocado el suelo. Total: ", grounded_objects_count)
			area.get_node("Sprite2D").modulate = Color(0.5, 0.5, 0.5)
			# Comprobamos la condición de derrota (ahora con 10)
			if grounded_objects_count >= 10:
				game_over()



func _on_grounded_object_collected():
	if grounded_objects_count > 0:
		grounded_objects_count -= 1

	ui.update_grounded_objects(grounded_objects_count)
	print("RESTA: Se ha recogido un objeto del suelo. Total ahora: ", grounded_objects_count)


func _on_score_updated(points):
	score += points
	ui.update_score(score)

func _on_object_grounded():
	grounded_objects_count += 1
	print("Objetos en el suelo: ", grounded_objects_count)
	if grounded_objects_count > 10:
		game_over()

func game_over():
	print("GAME OVER")
	await fade_out_music(0.5)
	if player != null:
		player.die()
		
	spawn_timer.stop()
	# Guardamos el high score si es necesario
	if score > high_score:
		high_score = score
		save_high_score()
		
	Global.last_score = score
	Global.high_score = high_score
	
	#get_tree().change_scene_to_file("res://Scenes/UI/game_over.tscn")


func save_high_score():
	var file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	file.store_var(high_score)

func load_high_score():
	if FileAccess.file_exists("user://savegame.dat"):
		var file = FileAccess.open("user://savegame.dat", FileAccess.READ)
		high_score = file.get_var()
	else:
		high_score = 0
