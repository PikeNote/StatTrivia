extends TextureButton

var catInd = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func loadCat(i):
	catInd = i;
	$Label.text = Categories.categories[Categories.categoriesList[i]]["name"];
	$Label2.text = str(Categories.categories[Categories.categoriesList[i]]["questions"].size()) + " questions";

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
