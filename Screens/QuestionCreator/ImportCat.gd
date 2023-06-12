extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_btn_pressed():
	$".".visible = false;
	$TextEdit.text="";


func _on_submit_import_pressed():
	var jsonAttempt = JSON.parse_string($TextEdit.text);
	$"..".importCat(jsonAttempt)
	visible = false;

func _on_import_button_pressed():
	visible = true;
