extends Control

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_play_btn_pressed():
	$Transition.transition("res://CreateGame.tscn")

func _on_categories_btn_pressed():
	$Transition.transition("res://QuestionCreator/CategoryManagement.tscn")


func _on_credits_btn_pressed():
	$CreditsScreen.visible = true;
	$Transition._slide_object($CreditsScreen,"TOP",1,false);
	pass # Replace with function body.


func _on_quit_credits_pressed():
	$Transition._slide_object($CreditsScreen,"BOTTOM",1.5,true);
	pass # Replace with function body.
