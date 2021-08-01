extends Spatial

onready var rain = $Rain
onready var ground = $Floor.get_active_material(0)
onready var shader_material = rain.process_material

export var max_amount = 1000
export var init_vel = 0.0
export var height = 20.0

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
	rain.amount = max_amount
	rain.explosiveness = 0.0
	rain.emitting = true
	ground.set_shader_param("blend_raining", 0.0)

func _process(delta):
	timer += delta
	if timer < cycle or humidity >= 0.8:
		return
	humidity += delta * 0.1
	ground.set_shader_param("blend_raining", humidity)
	pass
