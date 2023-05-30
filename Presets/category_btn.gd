extends TextureButton

var active = false;

# Template
var data = {
	"name":"",
	"description":"",
	"questions":[
	]
}

var path = "";

func load(ob):
	data = ob;
	$Label.text = data["name"];
	

func set_filePath(p):
	path = p;

func get_filePath():
	return path;

func getData():
	return data;
	
func get_title():
	return data["name"];

func get_description():
	return data["description"]

func get_question_count():
	return data["questions"].size();
	
func writeFile():
	var file = FileAccess.open(path, FileAccess.WRITE_READ);
	file.store_string(JSON.stringify(data));

func _on_mouse_entered():
	self_modulate = Color.html("cfcfcf");

func _on_mouse_exited():
	if(!active):
		self_modulate = Color.html("ffffff");
	
func _setActive(b):
	active = b;
	if(active):
		_on_mouse_entered();
	else:
		_on_mouse_exited();

func _setText(s):
	$Label.text = s;

func _on_delete_button_pressed():
	$".".queue_free();

func _on_edit_button_pressed():
	EditCategory.data = data;
	EditCategory.path = path;
	EditCategory.currentCat = $".".get_index();
	get_tree().change_scene_to_file("res://QuestionCreator/CategoryCreation.tscn")
