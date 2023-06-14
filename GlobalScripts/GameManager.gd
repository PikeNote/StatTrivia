extends Node

var total_questions = 10;
var questions_correct = 0;
var questions = [];

var settings = {
	"showDefault":true
}

var settingsPath = "user://gameSettings.json";

func _ready():
	load_settings();

func load_settings():
	if(FileAccess.file_exists(settingsPath)):
		var settings_file = FileAccess.open(settingsPath, FileAccess.READ);
		settings  = JSON.parse_string(settings_file.get_as_text());
	else:
		save();
	print(settings);

func save():
	var settings_file = FileAccess.open(settingsPath, FileAccess.WRITE);
	settings_file.store_line(JSON.stringify(settings));
