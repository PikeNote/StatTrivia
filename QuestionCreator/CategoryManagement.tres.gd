extends Control

var category_btn = preload("res://Presets/category_btn.tscn");

var current_cat = null;
var cat_ind = -1;

var Msgpack = preload("res://msgpack.gd")

var ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
func gen_unique_string(length: int) -> String:
	var result = ""
	for i in range(length):
		result += ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()]
	return result

@onready var scrollbar = $QuestionList/VBoxContainer/QuestionBox.get_v_scroll_bar();

func _ready():
	scrollbar.changed.connect(handle_scrollbar_changed);
	var loadCats = [];
	$CategoryInfo.visible = false;
	var user_directory = DirAccess.open("user://");
	
	if(!user_directory.dir_exists("categories")):
		user_directory.make_dir("categories");
	else:
		print("loading")
		var cat_dir = DirAccess.open("user://categories");
		if cat_dir:
			cat_dir.list_dir_begin()
			var file_name = cat_dir.get_next()
			while file_name != "":
				if !cat_dir.current_is_dir():
					
					if(file_name.contains(".json")):
						var file = FileAccess.open("user://categories//"+file_name, FileAccess.READ)
						var content = file.get_as_text()
						var json = JSON.new()
						
						var json_obj = json.parse_string(content);
						json_obj["file_path"] = "user://categories//"+file_name;
						loadCats.append(json_obj)
					print("Found file: " + file_name)
				file_name = cat_dir.get_next()
		loadCats.sort_custom(func(a,b): return a["time_created"] > b["time_created"]);
		
		for catObject in loadCats:
			var inst_btn = category_btn.instantiate();
			inst_btn.set_filePath(catObject["file_path"]);
			catObject.erase("file_path");
			inst_btn.load(catObject);
			
			$QuestionList/VBoxContainer/QuestionBox/VBoxContainer.add_child(inst_btn);
			inst_btn.pressed.connect(cat_btn_click.bind(inst_btn))
		
		if(EditCategory.currentCat != -1):
			cat_btn_click($QuestionList/VBoxContainer/QuestionBox/VBoxContainer.get_child(EditCategory.currentCat));
			EditCategory.currentCat = -1;
			EditCategory.data = null;
			EditCategory.path = null;

func resetSelect():
	$CategoryInfo.visible = false;

func handle_scrollbar_changed():
	$QuestionList/VBoxContainer/QuestionBox.scroll_vertical = scrollbar.max_value

func setCurrentQuestionInactive():
	if(current_cat != null):
		current_cat._setActive(false);
		current_cat = null;

func cat_btn_click(btn):
	if(btn != null):
		setCurrentQuestionInactive();
		$CategoryInfo.visible = true;
		$CategoryInfo/Label2/Title.text = btn.get_title();
		$CategoryInfo/Label3/Description.text = btn.get_description();
		$CategoryInfo/Label4/QuestionCount.text = str(btn.get_question_count());
		btn._setActive(true);
		current_cat = btn;
	

func _on_add_cat_pressed():
	var inst_btn = category_btn.instantiate();
	inst_btn.set_filePath(getUnique());
	inst_btn.setCurrentTime();
	inst_btn.writeFile();
	inst_btn.load(inst_btn.getData());
	$QuestionList/VBoxContainer/QuestionBox/VBoxContainer.add_child(inst_btn);
	inst_btn.pressed.connect(cat_btn_click.bind(inst_btn));
	cat_btn_click(inst_btn);

func getUnique():
	var filePath = "user://categories//"+gen_unique_string(10)+".json";
	while (DirAccess.dir_exists_absolute(filePath)):
		filePath = "user://categories//"+gen_unique_string(10)+".json";
	return filePath;

func _on_quit_button_pressed():
	$Transition.transition("res://Main.tscn")
	pass # Replace with function body.

func importCat(data):
	var inst_btn = category_btn.instantiate();
	inst_btn.set_filePath(getUnique());
	inst_btn.load(data);
	inst_btn.writeFile();
	$QuestionList/VBoxContainer/QuestionBox/VBoxContainer.add_child(inst_btn);
	inst_btn.pressed.connect(cat_btn_click.bind(inst_btn));

func _on_export_pressed():
	if current_cat != null:
		var data = current_cat.getData()
		var stringData = JSON.stringify(data);

		DisplayServer.clipboard_set(stringData);
		$CategoryInfo/Export/Label2.visible = true;
		await get_tree().create_timer(1.25).timeout
		$CategoryInfo/Export/Label2.visible = false;
		
	pass # Replace with function body.

