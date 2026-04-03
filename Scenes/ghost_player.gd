extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var targetObject
var DialogPlayer
var Text
var DialogObject
var inDialog = false
var DialogCounter = 0
var isAsking = false
var Answer = 0
var QPlayer
var QText
var Global
var AlertSprite
var ObjSprite
func _ready() -> void:
	Text = $DialogPlayer/Label
	QPlayer = $DialogPlayer/QBackground
	DialogPlayer = $DialogPlayer
	QText = $DialogPlayer/QLabel
	DialogPlayer.visible = false
	Global = $"../Global"
	AlertSprite = $Sprite2D2
	ObjSprite = $Sprite2D3
	ObjSprite.visible = false
	AlertSprite.visible = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_pressed("A") && !inDialog:
		velocity.x = move_toward(velocity.x, -SPEED, 150)
		$Sprite2D.flip_h = true
	elif Input.is_action_pressed("D") && !inDialog:
		velocity.x = move_toward(velocity.x, SPEED, 150)
		$Sprite2D.flip_h = false
#============================================================================================

	if Input.is_action_just_pressed("E") && !targetObject == null && !inDialog:
		if (targetObject.has_method("Interact")):
			DialogObject = targetObject.call("Interact")
			
	if (!DialogObject == null && inDialog == false):
		DialogPlayer.visible = true
		Dialog(DialogObject)
	elif inDialog == true && isAsking == false:
		DialogPlayer.visible = true
		if Input.is_action_just_pressed("DialogEnter"):
			DialogCounter += 1
			Dialog(DialogObject)
	elif inDialog == true && isAsking == true:
		Dialog(DialogObject)
	else:
		DialogPlayer.visible = false
	
	print($"../Global".LetterPickedUp)
#===============================================================================
	if (isAsking):
		QPlayer.visible = true
		QText.visible = true
		if Input.is_action_just_pressed("Yes"):
			Answer = 1
		elif Input.is_action_just_pressed("No"):
			Answer = 2
	else:
		QText.visible = false
		QPlayer.visible = false
	
	velocity.x = move_toward(velocity.x, 0, 75);
	move_and_slide()
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Interactable"):
		targetObject = null
		print("In range ", area.name)
		if area.is_in_group("KeyItem"):
			ObjSprite.visible = false
		else:
			AlertSprite.visible = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Interactable"):
		targetObject = area
		print("In range ", area.name)
		if area.is_in_group("KeyItem"):
			ObjSprite.visible = true
		else:
			AlertSprite.visible = true

func Dialog(DiaObj: String) -> void:
	inDialog = true
	
	if (DiaObj == "GRWindow1"):
		Text.text = "..."
		if (DialogCounter == 1):
			Text.text = "Its snowing"
		elif (DialogCounter == 2):
			Text.text = "..."
		elif (DialogCounter == 3):
			Text.text = "He used to love playing in the snow."
		elif (DialogCounter == 4):
			DialogCounter = 0
			DialogObject = null
			inDialog = false
			
	elif (DiaObj == "GRDoor1" && Global.LetterPickedUp == false):
		Text.text = "..."
		if (DialogCounter == 1):
			Text.text = "There's still stuff I need to do."
		elif (DialogCounter == 2):
			DialogCounter = 0
			DialogObject = null
			inDialog = false

	elif (DiaObj == "GRDoor1") && Global.LetterPickedUp:
		Text.text = "..."
		if (DialogCounter == 1):
			Text.text = "Insert Entering here"
		elif (DialogCounter == 2):
			DialogCounter = 0
			DialogObject = null
			inDialog = false
	
	elif (DiaObj == "GRBed1" && Global.LetterPickedUp == false):
		Text.text = "..."
		if (DialogCounter == 1):
			Text.text = "Theres a spider on the bed."
		elif (DialogCounter == 2):
			Text.text = "It seems... Comfy"
		elif (DialogCounter == 3):
			Text.text = "..."
		elif DialogCounter == 4:
			Text.text = "Theres a letter on the bed."
		elif DialogCounter == 5:
			Text.text = "Take it?"
		elif DialogCounter == 6:
			isAsking = true
			if Answer == 1:
				Text.text = "You picked up the Letter"
				isAsking = false
			elif Answer == 2:
				Text.text = "You Left the Letter"
				isAsking = false
		elif DialogCounter == 7:
			if Answer == 1:
				$"../Global".LetterPickedUp = true
			DialogCounter = 0
			if (targetObject.has_method("RemoveFromGroup")):
				targetObject.call("RemoveFromGroup")
				ObjSprite.visible = false
			DialogObject = null
			inDialog = false
			Answer = 0
	
	elif (DiaObj == "GRBed1" && Global.LetterPickedUp):
		Text.text = "..."
		if (DialogCounter == 1):
			Text.text = "It seems alseep"
		elif DialogCounter == 2:
			DialogCounter = 0
			DialogObject = null
			inDialog = false

	else:
		DialogCounter = 0
		DialogObject = null
		inDialog = false
