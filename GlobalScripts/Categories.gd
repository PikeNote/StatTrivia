extends Node

var categories = {

}

var categoriesList = [];

var activeCategories = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	_loadDir("res://Categories//");

func reloadCat():
	categories={};
	categoriesList=[];
	activeCategories=[];
	_loadDir("res://Categories//");
	_loadDir("user://categories//");

func _loadDir(d):
	var dir = DirAccess.open(d);
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				var categoryDataFile = FileAccess.open(d+file_name, FileAccess.READ);
				var item_data_json = JSON.new();
				var parsed_json = item_data_json.parse_string(categoryDataFile.get_as_text());
				categoryDataFile.close();
				categories[parsed_json["name"]] = parsed_json;
			file_name = dir.get_next()
		# Refresh categories list after a reload.
		categoriesList = [];
		for item in categories:
			categoriesList.append(categories[item]["name"]);

func _randomQuestion(category, count):
	var randomQuestions = []
	var cat_questions = categories[category]["questions"].duplicate(true);
	for x in range(count):
		var randInd = randi()%cat_questions.size();
		var ranQues = cat_questions[randInd]
		cat_questions.remove_at(randInd);
		randomQuestions.append(ranQues);
	return randomQuestions;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
