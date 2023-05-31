extends Control

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_play_btn_pressed():
	$Transitioner.transition_scene(self, "res://CreateGame.tscn", 1, Tween.TRANS_SINE, Tween.EASE_OUT, BTrans.DIRECTION.RIGHT)

func _on_categories_btn_pressed():
	$Transitioner.transition_scene(self, "res://QuestionCreator/CategoryManagement.tscn", 1, Tween.TRANS_SINE, Tween.EASE_OUT, BTrans.DIRECTION.RIGHT)
