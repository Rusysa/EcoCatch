extends CanvasLayer

func _physics_process(delta):
	if Input.is_action_just_pressed("pausa"):
		get_tree().paused = not get_tree().paused
		$ColorRect.visible = not $ColorRect.visible
		$Label.visible = not $Label.visible
		$Label2.visible = not $Label2.visible
		$Button.visible = not $Button.visible


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
	
