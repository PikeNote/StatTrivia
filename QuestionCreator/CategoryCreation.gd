extends Control

var quesiton_btn = preload("res://Presets/question_btn.tscn")

var category = {
	"name":"",
	"description":"",
	"questions":[]
}

var currentQuestion;
var currentQuestionInd;

var checkNormal = load("res://assets/Check_Button.PNG");
var checkGreen = load("res://assets/Green_Check_Button.PNG");

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_on_button_1_pressed();
	
	
	$FileDialog.current_dir = ""
	if(EditCategory.currentCat != -1):
		load_data();
		
		
	for option in $QuestionSetup/CorrectButton.get_children():
		option.pressed.connect(correct_answer_pressed.bind(option));

func _on_texture_rect_pressed():
	$FileDialog.show();
	pass # Replace with function body.

func resetSel():
	for option in $QuestionSetup/CorrectButton.get_children():
		option.texture_normal = checkNormal;

func _on_file_dialog_file_selected(path):
	$QuestionSetup/ImageRect/TextureRect.visible = false;
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		print("err");
		pass;
	var texture = ImageTexture.new()
	texture.set_image(image)
	
	var file = FileAccess.open(path, FileAccess.READ);
	currentQuestion.setImage(Marshalls.raw_to_base64(file.get_buffer(file.get_length())));
	
	$QuestionSetup/ImageRect.texture_normal = texture;

func _on_button_pressed():
	DisplayServer.clipboard_set(JSON.stringify(category));
	pass # Replace with function body.

func setCurrentQuestionInactive():
	if(currentQuestion != null):
		currentQuestion._setActive(false);
		currentQuestion = null;
	$QuestionList/Button1.self_modulate = Color.html("ffffff");

func _on_add_cat_pressed():
	
	setCurrentQuestionInactive();
	
	currentQuestionInd = $QuestionList/VBoxContainer/QuestionBox/VBoxContainer.get_children().size() + 1;
	currentQuestion = quesiton_btn.instantiate();
	
	currentQuestion._setText("Question #"+str(currentQuestionInd));
	
	$QuestionList/VBoxContainer/QuestionBox/VBoxContainer.add_child(currentQuestion);
	
	currentQuestion.pressed.connect(_questionBtnClick.bind(currentQuestion));
	
	_questionBtnClick(currentQuestion);
	
func add_question():
	pass;
	
"""
Example structure
{
	"question":"",
	"image_data":"",
	"options":[
		"",
		"",
		"",
		""
	]
}
"""
func _questionBtnClick(btn):
	setCurrentQuestionInactive();
	
	currentQuestion = btn;
	currentQuestion._setActive(true);
	
	var data = btn.getData();
	$QuestionSetup/TextEdit.text = data["question"];
	
	if(data["image_data"] != ""):
		var image = Image.new();
		image.load_png_from_buffer(Marshalls.base64_to_raw(data["image_data"]));
		var image_texture = ImageTexture.new();
		image_texture.set_image(image);
		$QuestionSetup/ImageRect.texture_normal = image_texture
		$QuestionSetup/ImageRect/TextureRect.visible = false;
	else:
		$QuestionSetup/ImageRect.texture_normal = null;
		$QuestionSetup/ImageRect/TextureRect.visible = true;
	
	var i = 0;
	for grid_btn in $QuestionSetup/GridContainer.get_children():
		grid_btn.get_child(0).text = data["options"][i];
		i+=1;
		
	$QuestionSetup.visible = true;
	$CategoryInfo.visible = false;
	
	resetSel();

	$QuestionSetup/CorrectButton.get_child(data["correct"]).texture_normal = checkGreen;
	

func _on_button_1_pressed():
	setCurrentQuestionInactive();
	$QuestionList/Button1.self_modulate = Color.html("cfcfcf");
	$CategoryInfo.visible = true;
	$QuestionSetup.visible = false;

func _on_image_rect_pressed():
	$FileDialog.show();


func _option_changed(ind):
	currentQuestion.setOptions(ind, $QuestionSetup/GridContainer.get_child(ind).get_child(0).text);

func _question_text_changed():
	currentQuestion.setQuestion($QuestionSetup/TextEdit.text);



# Category change related scripts
func _on_line_edit_text_changed(new_text):
	EditCategory.data["name"] = new_text;

func _on_line_edit_lines_edited_from(from_line, to_line):
	pass # Replace with function body.

func _on_text_edit_text_changed():
	EditCategory.data["description"] = $CategoryInfo/Label3/TextEdit.text;


func load_data():
	$CategoryInfo/Label2/LineEdit.text = EditCategory.data["name"];
	$CategoryInfo/Label3/TextEdit.text = EditCategory.data["description"];
	
	for question in EditCategory.data["questions"]:
		var q_inst = quesiton_btn.instantiate();
		var ind = $QuestionList/VBoxContainer/QuestionBox/VBoxContainer.get_children().size() + 1;
		
		q_inst.setData(question);
		q_inst._setText("Question #"+str(ind));
		$QuestionList/VBoxContainer/QuestionBox/VBoxContainer.add_child(q_inst);
		q_inst.pressed.connect(_questionBtnClick.bind(q_inst));

		#$QuestionSetup/CorrectButton/Option_One.texture_normal = checkNormal;
		#$QuestionSetup/CorrectButton.get_child(EditCategory.data["correct"]).texture_normal = checkGreen;


func _on_save_button_pressed():
	EditCategory.data["questions"] = [];
	for ques_btn in $QuestionList/VBoxContainer/QuestionBox/VBoxContainer.get_children():
		EditCategory.data["questions"].append(ques_btn.getData());
	EditCategory.saveData();
	get_tree().change_scene_to_file("res://QuestionCreator/CategoryManagement.tscn");

func correct_answer_pressed(btn:TextureButton):
	resetSel();
	$QuestionSetup/CorrectButton.get_child(currentQuestion.getCorrect()).texture_normal = checkNormal;
	currentQuestion.setCorrect(btn.get_index());
	btn.texture_normal = checkGreen;



