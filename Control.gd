extends KinematicBody

export var linear_vel = 2.0
export var mouse_sens = 0.3
export var camera_anglev = 0

var camera_move = false
var viewmode = false
var active_obstacle = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if get_tree().paused and not viewmode:
		return
	if Input.is_action_pressed("move_right"):
		move_and_slide(global_transform.basis.x * linear_vel)
	if Input.is_action_pressed("move_left"):
		move_and_slide(global_transform.basis.x * -linear_vel)
	if Input.is_action_pressed("move_forward"):
		move_and_slide(global_transform.basis.z * -linear_vel)
	if Input.is_action_pressed("move_backward"):
		move_and_slide(global_transform.basis.z * linear_vel)
	if Input.is_action_pressed("move_up"):
		move_and_slide(global_transform.basis.y * linear_vel)
	if Input.is_action_pressed("move_down"):
		move_and_slide(global_transform.basis.y * -linear_vel)
	
func _process(delta):
	if Input.is_action_just_pressed("Esc"):
		camera_move = not camera_move
		get_parent().toggle_ui()
		if camera_move:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
		Input.action_release("Esc")

func _input(event):
	if event is InputEventMouseMotion and not get_tree().paused:
		if not camera_move:
			return
		global_rotate(Vector3.UP, deg2rad(-event.relative.x*mouse_sens))
		var changev=-event.relative.y*mouse_sens
		if camera_anglev+changev>-50 and camera_anglev+changev<50:
			camera_anglev+=changev
			rotate_object_local(Vector3.RIGHT, deg2rad(changev))


func _on_Area_area_entered(area):
	active_obstacle = area.get_node("Box")
	get_parent().toggle_obstacle(active_obstacle)

func _on_Viewmode_toggled(button_pressed):
	viewmode = not viewmode
