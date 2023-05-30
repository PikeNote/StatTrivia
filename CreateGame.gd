extends Control

var category_select_btn = preload("res://Presets/category_select_btn.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	Categories._loadDir("user://categories//");
	
	for i in range(Categories.categoriesList.size()):
		var inst_cat_btn = category_select_btn.instantiate();
		inst_cat_btn.loadCat(i);
		inst_cat_btn.pressed.connect(inst_btn_clicked.bind(inst_cat_btn));
		$InactiveCategories.add_child(inst_cat_btn);
		

func inst_btn_clicked(btn:TextureButton):
	var btnParentName = btn.get_parent().name;
	btn.get_parent().remove_child(btn);
	if(btnParentName == "InactiveCategories"):
		$ActiveCategories.add_child(btn)
	else:
		$InactiveCategories.add_child(btn);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_question_edit_value_changed(value):
	pass # Replace with function body.
