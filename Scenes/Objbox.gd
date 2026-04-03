extends Area2D
var asking = false
var QDisplay

func Interact() -> String:
	print("Interacted")
	return name

func RemoveFromGroup() -> void:
	remove_from_group("KeyItem")
	
