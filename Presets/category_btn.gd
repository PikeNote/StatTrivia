extends TextureButton

var active = false;

# Template
var data = {
	"name":"Your new category",
	"description":"Describe what you are making!",
	"questions":[
	],
	"time_created":0
}

var path = "";

func load(ob):
	data = ob;
	$Label.text = data["name"];
	
func setCurrentTime():
	data["time_created"] = Time.get_unix_time_from_system();

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
	DirAccess.remove_absolute(path);
	get_tree().get_root().get_node("CategoryManagement").resetSelect();
	$".".queue_free();
	

func _on_edit_button_pressed():
	EditCategory.data = data;
	EditCategory.path = path;
	EditCategory.currentCat = $".".get_index();
	get_node('/root/CategoryManagement/Transitioner').transition_scene(self, "res://QuestionCreator/CategoryCreation.tscn", 1, Tween.TRANS_SINE, Tween.EASE_OUT, BTrans.DIRECTION.RIGHT)

	
	
