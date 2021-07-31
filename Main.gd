extends Spatial

onready var rain = $Rain
onready var shader_material = rain.process_material
export var max_amount = 20000
export var amount_variation = 1.3

var timer = 0.0

onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	rain.lifetime =  shader_material.get_shader_param("max_height") / gravity
	shader_material.set_shader_param("gravity", gravity)


func _process(delta):
	pass
