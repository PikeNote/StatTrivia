extends TextureButton

var active = false;

var data = {
	"question":"",
	"image_data":"",
	"options":[
		"",
		"",
		"",
		""
	]
}

func setImage(s):
	data["image_data"] = s;

func setQuestion(s):
	data["question"] = s;
	
func setOptions(i,s):
	data["options"][i] = s;

func getData():
	return data;

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
