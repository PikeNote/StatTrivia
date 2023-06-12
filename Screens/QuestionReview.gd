extends Control


var QuestionListItem = preload("res://Presets/question_list_item.tscn");
var catBreakdown = preload("res://Presets/category_progress.tscn")
var category_breakdown = {
	
}
var correct = 0;
var total = 0;
var correct_btn = Color.html("288b3f")
var wrong_btn = Color.html("cc4147")

# Called when the node enters the scene tree for the first time.
func _ready():
	for q in QuestionData.questions:
		var qInstItem = QuestionListItem.instantiate();
		qInstItem.setData(q);
		$"Question List/VBoxContainer".add_child(qInstItem);
		qInstItem.pressed.connect(buttonCatPressed.bind(qInstItem));
		if(!q["category_origin"] in category_breakdown):
			category_breakdown[q["category_origin"]] = {
				"correct":0,
				"total":0
			}
		category_breakdown[q["category_origin"]]["total"] += 1;
		total+=1;
		if(!"wrong_ind" in q):
			category_breakdown[q["category_origin"]]["correct"] += 1;
			correct+=1;
	
	for cat_correct in category_breakdown:
		var instCatBreakdown = catBreakdown.instantiate();
		instCatBreakdown.load(cat_correct, category_breakdown[cat_correct]);
		$OverviewItems/ActiveCats/ScrollContainer/VBoxContainer.add_child(instCatBreakdown);
	
	$OverviewItems/Score_Report/Value.text = str(correct) + "/" + str(total);
	
	var timeTaken = int(QuestionData.endTime - QuestionData.startTime);
	var seconds = timeTaken%60;
	var minutes = floor(timeTaken/60);
	$OverviewItems/Time_Taken/Value.text = str(minutes) + ":" + str(seconds) + " Minutes";
	$OverviewBTN.setActive(true);

func buttonCatPressed(btn):
	var data = btn.getData();
	if(data.has("image_data") && len(data["image_data"]) != 0):
		var image = Image.new();
		image.load_jpg_from_buffer(PackedByteArray(data["image_data"]).decompress_dynamic(-1,3));
		var image_texture = ImageTexture.new();
		image_texture.set_image(image);
		$ShowQuestion/ImageQuestion/image.texture = image_texture
		$ShowQuestion/ImageQuestion/question_text.text = data["question"];
		$ShowQuestion/question_text.visible = false;
		$ShowQuestion/ImageQuestion.visible = true;
	else:
		$ShowQuestion/question_text.text = data["question"];
	
	var i = 0;
	for option in data["options"]:
		$ShowQuestion/GridContainer.get_child(i).get_child(0).visible = false;
		$ShowQuestion/GridContainer.get_child(i).get_child(1).text = option;
		i+=1;
	
	if(data.has("wrong_ind")):
		var wrongColorRect = $ShowQuestion/GridContainer.get_child(data["wrong_ind"]).get_child(0);
		print(data["wrong_ind"])
		wrongColorRect.get_child(0).self_modulate = wrong_btn;
		wrongColorRect.visible = true;
	
	print(data["correct"])
	var correctOptionRect = $ShowQuestion/GridContainer.get_child(data["correct"]).get_child(0)
	
	correctOptionRect.get_child(0).self_modulate = correct_btn;
	correctOptionRect.visible = true;
	
	print(correctOptionRect.visible)
	
	$ShowQuestion.visible = true;
	
func _on_quit_button_pressed():
	$ShowQuestion.visible = false;
	pass # Replace with function body.


func _on_main_quit_button_pressed():
	$Transition.transition("res://Screens/MainMenu.tscn");

func _on_overview_btn_pressed():
	$"Question List".visible = false;
	$OverviewItems.visible = true;
	$OverviewBTN.setActive(true);
	$QuestionListBTN.setActive(false);
	$OverviewLabel.text = "Question Overview"
	pass # Replace with function body.


func _on_question_list_btn_pressed():
	$"Question List".visible = true;
	$OverviewItems.visible = false;
	$OverviewBTN.setActive(false);
	$QuestionListBTN.setActive(true);
	$OverviewLabel.text = "Question List"
