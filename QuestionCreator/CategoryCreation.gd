extends Node2D


var currentBase64 = "";

# Called when the node enters the scene tree for the first time.
func _ready():
	$FileDialog.current_dir = ""
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_rect_pressed():
	$FileDialog.show();
	pass # Replace with function body.


func _on_file_dialog_file_selected(path):
	$ImageRect/TextureRect.visible = false;
	var image = Image.new()
	var err = image.load(path)
	if err != OK:
		print("err");
		pass;
	var texture = ImageTexture.new()
	texture.set_image(image)
	
	var file = FileAccess.open(path, FileAccess.READ);
	currentBase64 = Marshalls.raw_to_base64(file.get_buffer(file.get_length()))
	
	$ImageRect.texture_normal = texture;

	
	pass # Replace with function body.


func _on_button_pressed():
	var data = {
		"question":$TextEdit.text,
		"image_data":currentBase64,
		"options":[
			$GridContainer/Button1/LineEdit.text,
			$GridContainer/Button2/LineEdit.text,
			$GridContainer/Button3/LineEdit.text,
			$GridContainer/Button4/LineEdit.text
		]
	}
	DisplayServer.clipboard_set(JSON.stringify(data));
	pass # Replace with function body.



func _on_image_rect_pressed():
	$FileDialog.show();
