@tool
@icon("res://addons/BTransition/BTransition.svg")
extends EditorPlugin
class_name BTrans

## Globals for the transition addon
##
## Contains global variables and enumerations for the transition addon.
## [br][br]To use transitions, instance a [Transitioner] node instead.

enum DIRECTION {
	LEFT, ## Left direction for scene transitions
	RIGHT, ## Right direction for scene transitions
	UP, ## Up direction for scene transitions
	DOWN ## Down direction for scene transitions
}

func _enter_tree():
	# Initialization of the plugin goes here.
	pass

func _exit_tree():
	# Clean-up of the plugin goes here.
	pass
