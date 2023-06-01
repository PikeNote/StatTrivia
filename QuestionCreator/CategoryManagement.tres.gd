extends Control

var category_btn = preload("res://Presets/category_btn.tscn");
var file_count = 0;

var current_cat = null;
var cat_ind = -1;

var Msgpack = preload("res://msgpack.gd")

func _ready():
	$CategoryInfo.visible = false;
	var user_directory = DirAccess.open("user://");
	
	if(!user_directory.dir_exists("categories")):
		user_directory.make_dir("categories");
	else:
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
						var json_obj = json.parse_string(content)
						
						var inst_btn = category_btn.instantiate();
						inst_btn.load(json_obj);
						inst_btn.set_filePath("user://categories//"+file_name);
						$QuestionList/VBoxContainer/QuestionBox/VBoxContainer.add_child(inst_btn);
						inst_btn.pressed.connect(cat_btn_click.bind(inst_btn))
						file_count+=1;
					
					
					print("Found file: " + file_name)
				file_name = cat_dir.get_next()
		if(EditCategory.currentCat != -1):
			cat_btn_click($QuestionList/VBoxContainer/QuestionBox/VBoxContainer.get_child(EditCategory.currentCat));
			EditCategory.currentCat = -1;
			EditCategory.data = null;
			EditCategory.path = null;

func setCurrentQuestionInactive():
	if(current_cat != null):
		current_cat._setActive(false);
		current_cat = null;

func cat_btn_click(btn):
	setCurrentQuestionInactive();
	$CategoryInfo.visible = true;
	$CategoryInfo/Label2/Title.text = btn.get_title();
	$CategoryInfo/Label3/Description.text = btn.get_description();
	$CategoryInfo/Label4/QuestionCount.text = str(btn.get_question_count());
	btn._setActive(true);
	current_cat = btn;
	

func _on_add_cat_pressed():
	var inst_btn = category_btn.instantiate();
	inst_btn.set_filePath("user://categories//newCategory"+str(file_count+1)+".json");
	inst_btn.writeFile();
	$QuestionList/VBoxContainer/QuestionBox/VBoxContainer.add_child(inst_btn);
	inst_btn.pressed.connect(cat_btn_click.bind(inst_btn));
	file_count+=1;


func _on_quit_button_pressed():
	$Transitioner.transition_scene(self, "res://Main.tscn", 1, Tween.TRANS_SINE, Tween.EASE_OUT, BTrans.DIRECTION.LEFT)
	pass # Replace with function body.

func importCat(data):
	var inst_btn = category_btn.instantiate();
	inst_btn.set_filePath("user://categories//newCategory"+str(file_count+1)+".json");
	inst_btn.load(data);
	inst_btn.writeFile();
	$QuestionList/VBoxContainer/QuestionBox/VBoxContainer.add_child(inst_btn);
	inst_btn.pressed.connect(cat_btn_click.bind(inst_btn));
	file_count+=1;

func _on_export_pressed():
	if current_cat != null:
		var data = current_cat.getData()
		var poolbyteData = var_to_bytes(JSON.stringify(data));
		poolbyteData = poolbyteData.compress(3);
		
		DisplayServer.clipboard_set(JSON.stringify(poolbyteData).replace('"',""))
		$CategoryInfo/Export/Label2.visible = true;
		await get_tree().create_timer(1.25).timeout
		$CategoryInfo/Export/Label2.visible = false;
		
	pass # Replace with function body.

