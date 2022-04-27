extends KinematicBody

var vertical_velocity = 0
var gravity = -9.81*2
var jump_strength = 10

var speed = 10

var look_sensitivity = 0.5
var vertical_look_limit = 90

onready var head = $Head

		
func _physics_process(delta):
	
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"): direction -= global_transform.basis.z
	if Input.is_action_pressed("move_backward"): direction += global_transform.basis.z
	if Input.is_action_pressed("move_left"): direction -= global_transform.basis.x
	if Input.is_action_pressed("move_right"): direction += global_transform.basis.x
	
	if is_on_floor(): 
		vertical_velocity = 0
		if Input.is_action_just_pressed("jump"): vertical_velocity = jump_strength
	else: vertical_velocity += -gravity * delta
	
	var velocity = direction.normalized()*speed + Vector3.UP * vertical_velocity
	move_and_slide(velocity,Vector3.UP)
	
	
func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x)*look_sensitivity)
		head.rotate_x(deg2rad(-event.relative.y)*look_sensitivity)
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -vertical_look_limit, vertical_look_limit)
		
	if Input.is_action_just_pressed("ui_cancel"): 
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE)


