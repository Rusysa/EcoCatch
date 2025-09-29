extends Control

# Asegúrate de que estas rutas apunten a tus nodos Label
@onready var score_label = $VBoxContainer/ScoreLabel
@onready var high_score_label = $VBoxContainer/HighScoreLabel

func _ready():
	# Tomamos las puntuaciones del script Global que configuramos
	score_label.text = "Tu puntuación: %s" % Global.last_score
	high_score_label.text = "Mejor puntuación: %s" % Global.high_score

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pausa"):
		get_tree().change_scene_to_file("res://main_menu.tscn")

# Esta función se conectará al botón de Reiniciar
func _on_restart_button_pressed():
	# Recarga la escena principal del juego
	get_tree().change_scene_to_file("res://Scenes/levels/Main.tscn")

# Esta función se conectará al botón de Menú Principal
func _on_menu_button_pressed():
	# Te envía a tu escena de menú. ¡Asegúrate de que la ruta sea correcta!
	get_tree().change_scene_to_file("res://main_menu.tscn")
