extends TextureButton

var catInd = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func loadCat(i):
	catInd = i;
	$ScrollContainer/Title.text = Categories.categories[Categories.categoriesList[i]]["name"];
	$QuestionLabel.text = str(getQuestionCount()) + " questions";
	
	

func getCat():
	return catInd;

func getQuestionCount():
	return Categories.categories[Categories.categoriesList[catInd]]["questions"].size();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	self_modulate = Color.html("cfcfcf");

func _on_mouse_exited():
	self_modulate = Color.html("ffffff");
