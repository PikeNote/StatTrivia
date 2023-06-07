extends Control


var QuestionListItem = preload("res://Presets/question_list_item.tscn");
var correct_btn = load("res://Color 5/Button_Green.png");
var wrong_btn = load("res://Color 5/Button_Red.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	for q in QuestionData.questions:
		var qInstItem = QuestionListItem.instantiate();
		qInstItem.setData(q);
		$"Question List/VBoxContainer".add_child(qInstItem);
		qInstItem.pressed.connect(buttonCatPressed.bind(qInstItem));


func buttonCatPressed(btn):
	var data = btn.getData();
	if(data.has("image_data") && data["image_data"] != ""):
		var image = Image.new();
		image.load_png_from_buffer(Marshalls.base64_to_raw(data["image_data"]));
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
		$ShowQuestion/GridContainer.get_child(i).text = option;
	
	if(data.has("wrong_ind")):
		var wrongColorRect = $ShowQuestion/GridContainer.get_child(data["wrong_ind"]).get_child(0);
		wrongColorRect.texture = wrong_btn;
		wrongColorRect.visible = true;

	var correctOptionRect = $ShowQuestion/GridContainer.get_child(data["correct"]).get_child(0)
	correctOptionRect.visible = true;
	correctOptionRect.texture = correct_btn;
	
	$ShowQuestion.visible = true;
	
func _on_quit_button_pressed():
	$ShowQuestion.visible = false;
	pass # Replace with function body.


func _on_main_quit_button_pressed():
	$Transitioner.transition_scene(self, "res://Main.tscn", 1, Tween.TRANS_SINE, Tween.EASE_OUT, BTrans.DIRECTION.LEFT)

