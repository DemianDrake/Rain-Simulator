extends Spatial

onready var rain = $Rain
onready var shader_material = rain.process_material

export var max_amount = 20000
export var init_vel = 0.0
export var max_height = 20.0

var timer = 0.0

onready var g = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	shader_material.set_shader_param("gravity", g)
	shader_material.set_shader_param("amount", rain.amount)
	shader_material.set_shader_param("max_height", max_height)
	shader_material.set_shader_param("init_vel", init_vel)
	rain.lifetime = (sqrt(init_vel * init_vel + (2 * g * max_height)) - init_vel) / g
	rain.emitting = true
