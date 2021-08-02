extends Spatial

onready var control = $Control
onready var rain = $Rain
onready var ui = $UI
onready var ground = $Floor.get_active_material(0)
onready var rain_shader = rain.process_material

export var max_amount = 1000
export var init_vel = 0.0
export var height = 20.0
var cam_speed = 5.0

export var wind_direction_angle = 150.0;
export var wind_power = 4.0;


onready var g = ProjectSettings.get_setting("physics/3d/default_gravity")

var humidity = 0.0
var cycle = 1.0
var timer = 0.0

func _ready():
	rain_shader.set_shader_param("gravity", g)
	rain_shader.set_shader_param("amount", max_amount)
	rain_shader.set_shader_param("height", height)
	rain_shader.set_shader_param("init_vel", init_vel)
	
	rain_shader.set_shader_param("wind_direction_angle", wind_direction_angle)
	rain_shader.set_shader_param("wind_power", wind_power)
	
	cycle = (sqrt(init_vel * init_vel + (2 * g * height)) - init_vel) / g
	rain.lifetime = cycle
	rain.amount = max_amount
	rain.explosiveness = 0.0
	rain.emitting = true
	ground.set_shader_param("blend_raining", 0.0)
	control.linear_vel = cam_speed
	
	get_tree().paused = true

func _process(delta):
	if get_tree().paused:
		return
	timer += delta
	if timer < cycle or humidity >= 0.8:
		return
	humidity += delta * 0.1
	ground.set_shader_param("blend_raining", humidity)
	
func toggle_ui():
	if self.is_a_parent_of(ui):
		remove_child(ui)
	else:
		add_child(ui)
	

func toggle_obstacle(obstacle):
	# Here's where I get the collider's vertices 
	# so I can send them to the shader
	# ... if I knew how...
	pass


func _on_Enter_pressed():
	rain_shader.set_shader_param("amount", max_amount)
	rain.amount = max_amount
	rain_shader.set_shader_param("height", height)
	cycle = (sqrt(init_vel * init_vel + (2 * g * height)) - init_vel) / g
	rain.lifetime = cycle
	rain_shader.set_shader_param("init_vel", init_vel)
	rain_shader.set_shader_param("wind_direction_angle", wind_direction_angle)
	rain_shader.set_shader_param("wind_power", wind_power)
	ground.set_shader_param("blend_raining", 0.0)
	#rain.restart()
	Input.action_press("Esc")


func _on_Wind_Power_text_changed(new_text):
	wind_power = float(new_text)


func _on_Wind_Degree_text_changed(new_text):
	wind_direction_angle = float(new_text)


func _on_Vel_text_changed(new_text):
	init_vel = float(new_text)


func _on_Height_text_changed(new_text):
	height = float(new_text)


func _on_Amount_text_changed(new_text):
	max_amount = int(new_text)
