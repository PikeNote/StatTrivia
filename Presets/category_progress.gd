extends TextureRect

"""
 {
	"correct":0,
	"total":0
}
"""
func load(n,d):
	$Title.text = n;
	$AmountCorrect.text = str(d["correct"]) + "/" + str(d["total"]);
	$ProgressBar.max_value = d["total"];
	$ProgressBar.value = d["correct"];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
