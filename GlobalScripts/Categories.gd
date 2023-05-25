extends Node

var categories = {

}

var categoriesList = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	var dir = DirAccess.open("res://Categories/");
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				print(file_name)
				var categoryDataFile = FileAccess.open("res://Categories/"+file_name, FileAccess.READ);
				var item_data_json = JSON.new();
				var parsed_json = item_data_json.parse_string(categoryDataFile.get_as_text());
				categoryDataFile.close();
				categoriesList.append(parsed_json["name"]);
				categories[parsed_json["name"]] = parsed_json["questions"];
			file_name = dir.get_next()
	
	pass # Replace with function body.

func _randomQuestion(category, count):
	var randomQuestions = []
	var cat_questions = categories[category];
	for x in range(count):
		var ranQues = cat_questions[randi()%cat_questions.size()]
		cat_questions.erase(ranQues);
		randomQuestions.append(ranQues);
	return randomQuestions;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
