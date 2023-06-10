extends TextureButton

var data = {
	
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setData(d):
	data = d;
	if(data.has("wrong_ind")):
		$CorrectWrong.texture = load("res://Color 5/x.png")
	$QuestionTitle.text = data["question"].replace("\n", "");
	$CategoryTag/Label.text = data["category_origin"];
func getData():
	return data;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
