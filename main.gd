extends Node2D
var Player

func _ready() -> void:
	Player = preload("res://Scenes/GhostPlayer.tscn")

# Called when the node enters the scene tree for the first time.
func exit(Level):
	var nextlevel = Level.instantiate()
	add_child(nextlevel)
	return nextlevel
	
	
