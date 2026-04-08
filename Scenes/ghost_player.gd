extends CharacterBody2D
@onready var fade: CanvasLayer = $Fade
@onready var main: Node2D = $".."





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
var Globalde
var AlertSprite
var ObjSprite
var current_level : Node2D = null
var WinterLevel = preload("res://Scenes/Winter.tscn")
var WinterIndoorRoom1 = preload("res://Scenes/LevelTesting.tscn")
var SpringLevel = preload("res://Scenes/Spring.tscn")
var nextlevel = null
@onready var global: Node2D = $Global

func _ready() -> void:
	Text = $DialogPlayer/Label
	QPlayer = $DialogPlayer/QBackground
	DialogPlayer = $DialogPlayer
	QText = $DialogPlayer/QLabel
	DialogPlayer.visible = false
	AlertSprite = $Sprite2D2
	ObjSprite = $Sprite2D3
	ObjSprite.visible = false
	AlertSprite.visible = false
	current_level = $"../Winter"


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
	
#===============================================================================
	if (isAsking):
		QPlayer.visible = true
		QText.visible = true
		if Input.is_action_just_pressed("Yes"):
			Answer = 1
		if Input.is_action_just_pressed("No"):
			Answer = 2
	else:
		QText.visible = false
		QPlayer.visible = false
	
	velocity.x = move_toward(velocity.x, 0, 75);
	move_and_slide()
#=====================================================================================
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
			

	elif (DiaObj == "GRDoor1" && global.LetterPickedUp == false):
		Text.text = "..."
		if (DialogCounter == 1):
			Text.text = "There's still stuff I need to do."
		elif (DialogCounter == 2):
			DialogCounter = 0
			DialogObject = null
			inDialog = false

	elif (DiaObj == "GRDoor1") && global.LetterPickedUp:
		Text.text = "..."
		if (DialogCounter == 1):
			await fade.fade(1.0, 1).finished
			nextlevel = main.exit(WinterLevel)
			position.x = 352.0
			position.y = 0
			current_level.queue_free()
			current_level = nextlevel
			
			await fade.fade(0, 1).finished
			DialogCounter = 0
			DialogObject = null
			inDialog = false
	
	elif (DiaObj == "GRBed1" && global.LetterPickedUp == false):
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
				global.LetterPickedUp = true
			DialogCounter = 0
			if (targetObject.has_method("RemoveFromGroup")):
				targetObject.call("RemoveFromGroup")
				ObjSprite.visible = false
			DialogObject = null
			inDialog = false
			Answer = 0
	
	elif (DiaObj == "GRBed1" && global.LetterPickedUp):
		Text.text = "..."
		if (DialogCounter == 1):
			Text.text = "It seems alseep"
		elif DialogCounter == 2:
			DialogCounter = 0
			DialogObject = null
			inDialog = false

	elif (DiaObj == "WinterOutdoor1"):
		Text.text = "..."
		if DialogCounter == 1:
			Text.text = "Enter?"
		if DialogCounter == 2:
			isAsking = true
			if Answer == 1:
				Answer = 0
				isAsking = false
				DialogObject = null
				inDialog = false
				Answer = 0

				await fade.fade(1.0, 1).finished
				nextlevel = main.exit(WinterIndoorRoom1)
				position.x = -425
				position.y = 201
				current_level.queue_free()
				current_level = nextlevel
				
				await fade.fade(0, 1).finished
				
			if Answer == 2:
				Text.text = "..."
				isAsking = false
				Answer = 0
		elif DialogCounter == 3:
			DialogObject = null
			inDialog = false
			Answer = 0

	elif (DiaObj == "SpringOutDoor1" && !global.MailBoxCheck):
		Text.text = "..."
		if DialogCounter == 1:
			Text.text = "You hear a faint sound of a TV"
		elif (DialogCounter == 2):
			Text.text = "..."
		elif (DialogCounter == 3):
			Text.text = "She's crying again"
		elif DialogCounter == 4:
			Text.text = "I wish she'd smile again"
		elif DialogCounter == 5:
			DialogObject = null
			inDialog = false
			DialogCounter = 0
			Answer = 0
	elif (DiaObj == "SpringWindowOutdoor1"):
		Text.text = "..."
		if DialogCounter == 1:
			Text.text = "She seems unwell."
		if DialogCounter == 2:
			Text.text = "I miss the days when we were together."
		elif DialogCounter == 3:
			DialogObject = null
			DialogCounter = 0
			inDialog = false
			Answer = 0
			
	elif (DiaObj == "SpringOutDoor1" && global.MailBoxCheck == true):
		Text.text = "..."
		if DialogCounter == 1:
			Text.text = "She seems unwell."
		elif DialogCounter == 2:
			Text.text = "I miss the days when we were together."
		elif DialogCounter == 3:
			Text.text = "Knock on Door?"
		elif DialogCounter == 4:
			isAsking = true
			if Answer == 1:
				Text.text = "*Knock Knock*"
				isAsking = false
			elif Answer == 2:
				"Maybe next time..."
				isAsking = false
		elif DialogCounter == 5 && Answer == 1:
			Text.text = "You hear someone get up."
		elif DialogCounter == 6 && Answer == 1:
			DialogObject = null
			DialogCounter = 0
			inDialog = false
			Answer = 0
		elif (DialogCounter > 4 && Answer == 2):
			DialogObject = null
			DialogCounter = 0
			inDialog = false
			Answer = 0

	elif (DiaObj == "SpringMailBox" && !global.MailBoxCheck):
		Text.text = "..."
		if DialogCounter == 1:
			Text.text = "Its a mailbox"
		elif DialogCounter == 2:
			Text.text = "It has not been used in a very very long time"
		elif DialogCounter == 3:
			Text.text = "Put the letter in the mailbox?"
		elif (DialogCounter == 4):
			isAsking = true
			if Answer == 1:
				Text.text = "You put the letter in the mail box"
				isAsking = false
			elif Answer == 2:
				"No letter for you..."
				isAsking = false
		elif DialogCounter == 5:
			if Answer == 1:
				global.MailBoxCheck = true
				if (targetObject.has_method("RemoveFromGroup")):
					targetObject.call("RemoveFromGroup")
				ObjSprite.visible = false
			DialogObject = null
			DialogCounter = 0
			inDialog = false
			Answer = 0
			
	elif (DiaObj == "SpringMailBox" && global.MailBoxCheck):
		Text.text == "..."
		if DialogCounter == 1:
			Text.text = "Still a mail box"
		if DialogCounter == 2:
			DialogObject = null
			DialogCounter = 0
			inDialog = false
			Answer = 0
	
	elif (DiaObj == "MoveToSpring" && !global.LetterPickedUp):
		Text.text = "..."
		if DialogCounter == 1:
			Text.text = "Theres something I forgot"
		elif DialogCounter == 2:
			Text.text = "I believe it was in my room"
		elif DialogCounter == 3:
			DialogObject = null
			DialogCounter = 0
			inDialog = false
			Answer = 0
	elif (DiaObj == "MoveToSpring" && global.LetterPickedUp):
		Text.text = "..."
		if DialogCounter == 1:
				await fade.fade(1.0, 1).finished
				nextlevel = main.exit(SpringLevel)
				position.x = -535
				position.y = 160
				current_level.queue_free()
				current_level = nextlevel
				DialogObject = null
				DialogCounter = 0
				inDialog = false
				Answer = 0
				await fade.fade(0, 1).finished
	
	
	
	
	else:
		DialogCounter = 0
		DialogObject = null
		inDialog = false
