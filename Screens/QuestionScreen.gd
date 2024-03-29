extends Control

var questions = [];
var currentQuestion = 0;
var correctAnswer = 0;
var labels = [];


var correct_btn = Color.html("288b3f")
var wrong_btn = Color.html("cc4147")

var disableInput = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	QuestionData.questions = [];
	randomize();
	_resetVisiblity();
	for button in $GridContainer.get_children():
		labels.append(button.get_child(1));
		button.pressed.connect(self._on_button_pressed.bind(button));
	
	var numberOfQuestions = floor(GameManager.total_questions/Categories.activeCategories.size())
	print(GameManager.total_questions)
	print(Categories.activeCategories.size());
	var remainder = GameManager.total_questions % Categories.activeCategories.size();
	
	for cat in Categories.activeCategories:
		var randomCatQuestion = Categories._randomQuestion(cat,numberOfQuestions);
		for i in range(randomCatQuestion.size()):
			randomCatQuestion[i]["category_origin"] = cat;
		questions += randomCatQuestion;
	questions.shuffle();
	#questions = Categories._randomQuestion("One Variable Data",5);
	
	for i in range(remainder):
		var uniqueQues = generateUniqueQues();
		uniqueQues[0]["category_origin"] = uniqueQues[1];
		questions.append(uniqueQues[0]);
	
	
	_setQuestion(currentQuestion);
	
	_updateQuestionProgress();
	
	QuestionData.startTime = Time.get_unix_time_from_system();
	
	pass # Replace with function body.

func generateUniqueQues():
	var randomCat = Categories.activeCategories[randi() % Categories.activeCategories.size()];
	var randQuestion = Categories._randomQuestion(randomCat,1);
	while questions.has(randQuestion[0]):
		randQuestion = Categories._randomQuestion(randomCat,1);
	return [randQuestion[0],randomCat];

func _setQuestion(s):
	var question_data = questions[s].duplicate(true);
	
	
	if(question_data.has("image_data") && len(question_data["image_data"]) != 0):
		
		var image = Image.new();
		image.load_jpg_from_buffer(PackedByteArray(question_data["image_data"]).decompress_dynamic(-1,3));
		var image_texture = ImageTexture.new();
		image_texture.set_image(image);
		$ImageQuestion/image.texture = image_texture
		$ImageQuestion/question_text.text = question_data["question"];
		$question_text.visible = false;
		$ImageQuestion.visible = true;
	else:
		$question_text.visible = true;
		$ImageQuestion.visible = false;
		$question_text.text = question_data["question"];
	
	var randomCorrect = randi() % 4;
	labels[randomCorrect].text = question_data["options"][question_data["correct"]];
	correctAnswer = randomCorrect;
	question_data["options"].erase(labels[randomCorrect].text);
	for x in range(4):
		if(x != randomCorrect):
			var rand_answer = question_data["options"][randi() % question_data["options"].size()];
			labels[x].text = rand_answer;
			question_data["options"].erase(rand_answer);
		
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed(btn):
	if(!$AnimationPlayer.is_playing() && !disableInput):
		var ques_data = questions[currentQuestion]
		if(btn.get_index() == correctAnswer):
			btn.get_child(0).get_child(0).self_modulate = correct_btn;
			correctAnswer += 1;
		else:
			btn.get_child(0).get_child(0).self_modulate = wrong_btn;
			var correct = $GridContainer.get_child(correctAnswer).get_child(0)
			correct.visible = true;
			correct.get_child(0).self_modulate = correct_btn
			ques_data["wrong_ind"] = ques_data["options"].find(btn.get_child(1).text);
		QuestionData.questions.append(ques_data);
		btn.get_child(0).visible = true;
		$AnimationPlayer.play("expandingRect");
	
		


func _on_animation_player_animation_finished(anim_name):
	if(currentQuestion < questions.size()-1):
		currentQuestion += 1;
		_setQuestion(currentQuestion);
	else:
		disableInput = true;
		QuestionData.endTime = Time.get_unix_time_from_system();
		$Transition.transition("res://Screens/QuestionReview.tscn");
	$AnimationPlayer.seek(0,true);
	_updateQuestionProgress();
	_resetVisiblity();
	

func _updateQuestionProgress():
	$QuestionCount/QuestionNumber.text = str(currentQuestion+1) + "/" + str(questions.size())

func _resetVisiblity():
	for btn in $GridContainer.get_children():
		btn.get_child(0).visible = false;
