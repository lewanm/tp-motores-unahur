extends CharacterBody2D

@export var speed: float = 200.0

func _process(_delta):
	var input_direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_direction.x = 1
	if Input.is_action_pressed("ui_left"):
		input_direction.x = -1
	if Input.is_action_pressed("ui_up"):
		input_direction.y = -1
	if Input.is_action_pressed("ui_down"):
		input_direction.y = 1
		
	input_direction = input_direction.normalized()
	velocity = input_direction * speed #* _delta * 60
	
	move_and_slide()
