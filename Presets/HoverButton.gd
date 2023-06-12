extends TextureButton

var active = false;

func _ready():
	mouse_entered.connect(_on_Mouse_Enter);
	mouse_exited.connect(_on_Mouse_Leave);

func setActive(b):
	active = b;
	if(active):
		modulate = Color("e5e5e5");
	else:
		modulate = Color("ffffff");

func _on_Mouse_Enter():
	modulate = Color("e5e5e5");

func _on_Mouse_Leave():
	if(!active):
		modulate = Color("ffffff");

