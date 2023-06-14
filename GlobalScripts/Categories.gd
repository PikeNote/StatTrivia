extends Node

var categories = {

}

var categoriesList = [];

var activeCategories = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	if(GameManager.settings["showDefault"]):
		_loadDir("res://Categories//");

func reloadCat():
	categories={};
	categoriesList=[];
	activeCategories=[];
	if(GameManager.settings["showDefault"]):
		_loadDir("res://Categories//");
	_loadDir("user://categories//");

func _loadDir(d):
	var dir = DirAccess.open(d);
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		print(file_name);
		print(d+file_name)
		while file_name != "":
			if !dir.current_is_dir():
				if(ResourceLoader.exists(d+file_name)):
					var categoryDataFile = ResourceLoader.load(d+file_name).get_data();
					if(categoryDataFile):
						categories[categoryDataFile["name"]] = categoryDataFile;
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
