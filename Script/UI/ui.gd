extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var high_score_label = $HighScoreLabel
@onready var grounded_objects_label = $GroundedObjectsLabel # ¡Ajusta la ruta si es necesario!


func update_score(new_score):
	score_label.text = "Puntución: %s" % new_score

func update_high_score(new_high_score):
	high_score_label.text = "Mejor Puntuación: %s" % new_high_score

func update_grounded_objects(count):
	grounded_objects_label.text = "Objetos en suelo: %s / 10" % count
