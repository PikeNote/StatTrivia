extends TextureButton

func _ready():
	mouse_entered.connect(_on_Mouse_Enter);
	mouse_exited.connect(_on_Mouse_Leave);

func _on_Mouse_Enter():
	modulate = Color("e5e5e5")

func _on_Mouse_Leave():
	modulate = Color("ffffff")

