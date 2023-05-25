extends Node2D

var questions = [];
var currentQuestion = 0;
var correctAnswer = 0;
var labels = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in $GridContainer.get_children():
		labels.append(button.get_child(1));
		button.pressed.connect(self._on_button_pressed.bind(button));
	questions = Categories._randomQuestion("One Variable Data",5);
	print(questions.size())
	_setQuestion(currentQuestion);
	
	pass # Replace with function body.

func _setQuestion(s):
	var question_data = questions[s];
	
	
	if(question_data.has("image_data") && question_data["image_data"] != ""):
		
		var image = Image.new();
		image.load_png_from_buffer(Marshalls.base64_to_raw(question_data["image_data"]));
		var image_texture = ImageTexture.new();
		image_texture.set_image(image);
		$ImageQuestion/image.texture = image_texture
		$ImageQuestion/question_text.text = question_data["question"];
		$question_text.visible = false;
		$ImageQuestion.visible = true;
	else:
		$question_text.text = question_data["question"];
	
	var randomCorrect = randi() % 4;
	print(randomCorrect);
	labels[randomCorrect].text = question_data["correct"];
	correctAnswer = randomCorrect;
	
	for x in range(4):
		if(x != randomCorrect):
			var rand_answer = question_data["options"][randi() % question_data["options"].size()];
			labels[x].text = rand_answer;
			question_data["options"].erase(rand_answer);
		
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed(btn):
	if(btn.get_child(1) == labels[correctAnswer]):
		btn.get_child(0).color = Color.html("2aff65ca");
		correctAnswer += 1;
	else:
		btn.get_child(0).color = Color.html("#FF0000");
		var correct = $GridContainer.get_child(correctAnswer).get_child(0)
		correct.visible = true;
		correct.color = Color.html("2aff65ca");
		pass
	btn.get_child(0).visible = true;
	$AnimationPlayer.play("expandingRect");
	
		


func _on_animation_player_animation_finished(anim_name):
	if(currentQuestion < questions.size()-1):
		currentQuestion += 1;
		_setQuestion(currentQuestion);
	$AnimationPlayer.seek(0,true);
	_updateQuestionProgress();
	_resetVisiblity();
	pass # Replace with function body.

func _updateQuestionProgress():
	$QuestionCount/QuestionNumber.text = str(currentQuestion+1) + "/" + str(questions.size())

func _resetVisiblity():
	for btn in $GridContainer.get_children():
		btn.get_child(0).visible = false;
