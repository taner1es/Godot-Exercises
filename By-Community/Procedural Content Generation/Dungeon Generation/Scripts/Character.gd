extends KinematicBody2D

export var id = 0
export var speed = 250

var velocity = Vector2()

func _ready():
	$Tween.interpolate_property(  $Camera2D, "zoom"
								, Vector2(9, 9), Vector2(.5, .5)
								, 5.0, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.interpolate_property($Camera2D, "position"
								, Vector2(3000,50), get_parent().position
								, 5.0, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	$Tween.start()

func _input(event):
	if event.is_action_pressed('scroll_up'):
		$Camera2D.zoom = $Camera2D.zoom - Vector2(0.1, 0.1)
	if event.is_action_pressed('scroll_down'):
		$Camera2D.zoom = $Camera2D.zoom + Vector2(0.1, 0.1)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('ui_right'):
		velocity.x += 1
	if Input.is_action_pressed('ui_left'):
		velocity.x -= 1
	if Input.is_action_pressed('ui_up'):
		velocity.y -= 1
	if Input.is_action_pressed('ui_down'):
		velocity.y += 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	
