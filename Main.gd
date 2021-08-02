extends Spatial

onready var control = $Control
onready var rain = $Rain
onready var ground = $Floor.get_active_material(0)
onready var shader_material = rain.process_material

export var max_amount = 1000
export var init_vel = 0.0
export var height = 20.0
export var speed = 5.0

export var wind_direction_angle = 150.0;
export var wind_power = 4.0;


onready var g = ProjectSettings.get_setting("physics/3d/default_gravity")

var humidity = 0.0
var cycle = 1.0
var timer = 0.0

func _ready():
	shader_material.set_shader_param("gravity", g)
	shader_material.set_shader_param("amount", rain.amount)
	shader_material.set_shader_param("height", height)
	shader_material.set_shader_param("init_vel", init_vel)
	
	cycle = (sqrt(init_vel * init_vel + (2 * g * height)) - init_vel) / g
	rain.lifetime = cycle
	shader_material.set_shader_param("wind_direction_angle", wind_direction_angle)
	shader_material.set_shader_param("wind_power", wind_power)

	rain.lifetime = (sqrt(init_vel * init_vel + (2 * g * height)) - init_vel) / g
	origin/vg_rain
	rain.amount = max_amount
	rain.explosiveness = 0.0
	rain.emitting = true
	ground.set_shader_param("blend_raining", 0.0)
	control.linear_vel = speed

func _process(delta):
	timer += delta
	if timer < cycle or humidity >= 0.8:
		return
	humidity += delta * 0.1
	ground.set_shader_param("blend_raining", humidity)
	pass
