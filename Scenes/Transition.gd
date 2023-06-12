extends Node2D

var queuedScene = "";
signal transition_in_done
signal transition_out_done

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = true;
	$AnimationPlayer.play("Transition_In");
	
func transition(to_scene):
	queuedScene = to_scene;
	$AnimationPlayer.play("Transition_Out")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Transition_Out":
		get_tree().change_scene_to_file(queuedScene);
	elif anim_name == "Transition_In":
		emit_signal("transition_out_done");

func _slide_object(node:Control, direction, time, reverse):
	var tween = get_tree().create_tween();
	
	var default_position = node.position;
	var pos = node.position;
	
	var size = node.size;
	match(direction):
		"LEFT":
			pos[0] = 0-size[0];
		"RIGHT":
			pos[0] = get_viewport_rect().size[0] + size[0];
		"TOP":
			pos[1] = 0-size[1];
		"BOTTOM":
			pos[1] = get_viewport_rect().size[1] + size[1];
	
	
	
	if(!reverse):
		node.position = pos;
		tween.tween_property(node, "position", default_position, time);
	else:
		tween.tween_property(node, "position", pos, time);
		#node.visible = false;
		#node.position = default_position;
	pass;
