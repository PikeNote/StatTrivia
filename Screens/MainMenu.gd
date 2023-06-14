extends Control

var duringTween = false;

func _ready():
	$CheckBox.button_pressed = GameManager.settings["showDefault"];
	$CheckBox.toggled.connect(_on_check_box_toggled);
	pass # Replace with function body.

func _process(delta):
	pass

func _on_play_btn_pressed():
	$Transition.transition("res://Screens/CreateGame.tscn")

func _on_categories_btn_pressed():
	$Transition.transition("res://Screens/QuestionCreator/CategoryManagement.tscn")


func _on_credits_btn_pressed():
	if(!duringTween):
		duringTween = true;
		$CreditsScreen.visible = true;
		$Transition._slide_object($CreditsScreen,"TOP",1,false);


func _on_quit_credits_pressed():
	if(!duringTween):
		duringTween = true;
		$Transition._slide_object($CreditsScreen,"BOTTOM",1.5,true);

func _on_transition_tween_done():
	duringTween = false;

func _on_check_box_toggled(button_pressed):
	print(button_pressed)
	GameManager.settings["showDefault"] = button_pressed;
	GameManager.save();
