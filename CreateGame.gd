extends Control

var category_select_btn = preload("res://Presets/category_select_btn.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	Categories.reloadCat()
	
	for i in range(Categories.categoriesList.size()):
		var inst_cat_btn = category_select_btn.instantiate();
		inst_cat_btn.loadCat(i);
		inst_cat_btn.pressed.connect(inst_btn_clicked.bind(inst_cat_btn));
		$InactiveScroll/InactiveCategories.add_child(inst_cat_btn);
		

func inst_btn_clicked(btn:TextureButton):
	var btnParentName = btn.get_parent().name;
	btn.get_parent().remove_child(btn);
	if(btnParentName == "InactiveCategories"):
		$ActiveScroll/ActiveCategories.add_child(btn)
	else:
		$InactiveScroll/InactiveCategories.add_child(btn);
	_on_line_edit_value_changed($InstructionTwo2/LineEdit.value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_question_edit_value_changed(value):
	pass # Replace with function body.


func _on_play_button_pressed():
	if($ErrorMsg.visible == false):
		Categories.activeCategories = [];
		for active_cat in $ActiveScroll/ActiveCategories.get_children():
			Categories.activeCategories.append(Categories.categoriesList[active_cat.getCat()]);
		GameManager.total_questions = int($InstructionTwo2/LineEdit.value);
		$Transitioner.transition_scene(self, "res://QuestionTemp.tscn", 1, Tween.TRANS_SINE, Tween.EASE_OUT, BTrans.DIRECTION.RIGHT)


func getTotalQuestions():
	var q_count = 0;
	for cat_btn in $ActiveScroll/ActiveCategories.get_children():
		q_count += cat_btn.getQuestionCount();
	return q_count;

func _on_line_edit_value_changed(value):
	$ErrorMsg.visible = true;
	if(value > getTotalQuestions()):
		$ErrorMsg.text = "The number of questions selected is greater than the number of questions in the active categories."
	elif(value < $ActiveScroll/ActiveCategories.get_child_count()):
		$ErrorMsg.text = "The number of questions selected is less than the number active categories."
	elif(value == 0):
		$ErrorMsg.text = "The number of questions selected cannot be 0."
	else:
		$ErrorMsg.visible = false;


func _on_quit_button_pressed():
	$Transitioner.transition_scene(self, "res://Main.tscn", 1, Tween.TRANS_SINE, Tween.EASE_OUT, BTrans.DIRECTION.LEFT)
	pass # Replace with function body.
