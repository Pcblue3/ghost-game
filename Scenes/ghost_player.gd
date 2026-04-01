extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var targetObject
var DialogPlayer
var Text
var DialogObject
var inDialog = false
var DialogCounter = 0

func _ready() -> void:
	Text = $DialogPlayer/Label
	DialogPlayer = $DialogPlayer
	
	DialogPlayer.visible = false
	


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_pressed("A"):
		velocity.x = move_toward(velocity.x, -SPEED, 150)
	elif Input.is_action_pressed("D"):
		velocity.x = move_toward(velocity.x, SPEED, 150)
	
	if Input.is_action_just_pressed("E") && !targetObject == null:
		if (targetObject.has_method("Interact")):
			DialogObject = targetObject.call("Interact")
			
	if (!DialogObject == null && inDialog == false):
		DialogPlayer.visible = true
		Dialog(DialogObject)
	elif inDialog == true:
		DialogPlayer.visible = true
		if Input.is_action_just_pressed("DialogEnter"):
			DialogCounter += 1
			Dialog(DialogObject)
	else:
		DialogPlayer.visible = false
	
	velocity.x = move_toward(velocity.x, 0, 75);
	move_and_slide()
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("Interactable"):
		targetObject = null
		print("Left range ", area.name)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Interactable"):
		targetObject = area
		print("In range ", area.name)


func Dialog(DiaObj: String) -> void:
	inDialog = true
	
	if (DiaObj == "Ball"):
		Text.text = "I'm a Ball!"
		if (DialogCounter == 1):
			Text.text = "This is a test for dialog!"
			print("1")
		elif (DialogCounter == 2):
			print("2")
			Text.text = "I really hopes this works"
		elif (DialogCounter == 3):
			print("3")
			DialogCounter = 0
			DialogObject = null
			inDialog = false
			
	elif (DiaObj == "Ball2"):
		Text.text = "I'm ball two!"
		if (DialogCounter == 1):
			Text.text = "Oooo spooky ghosts"
		elif (DialogCounter == 2):
			Text.text = "You are..."
		elif (DialogCounter == 3):
			Text.text = "..."
		elif (DialogCounter == 4):
			Text.text = "Blocky... for a ghost"
		elif (DialogCounter == 5):
			DialogCounter = 0
			DialogObject = null
			inDialog = false
