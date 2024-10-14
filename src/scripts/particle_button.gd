extends Button

const CONFETTI_CONE_POSITION_WHEN_CLICKED: Vector2 = Vector2(3,12)
const CONFETTI_PARTICLES_POSITION_WHEN_CLICKED: Vector2 = Vector2(13,12)
const CONFETTI_PARTICLES_ORIGINAL_POSITION: Vector2 = Vector2(13,6)
const CONFETTI_PARTICLES_ORIGINAL_SIZE: Vector2 = Vector2(12,12)

export(PackedScene) var button_particles

var _confetti_tween: SceneTreeTween
var __

onready var confetti_particles: TextureRect = $HBoxContainer/Control/ConfettiParticles
onready var confetti_cone: TextureRect = $HBoxContainer/Control/ConfettiCone


func _ready() -> void:
	randomize()


func kill_tween() -> void:
	if is_instance_valid(_confetti_tween):
		_confetti_tween.stop()
		_confetti_tween.kill()


func _on_Button_pressed() -> void:
	_confetti_tween = create_tween().set_parallel()
	__ = _confetti_tween.tween_property(
		confetti_particles,
		"rect_size",
		Vector2(0,0),
		0.2
	)
	
	__ = _confetti_tween.tween_property(
		confetti_particles,
		"rect_position",
		CONFETTI_PARTICLES_POSITION_WHEN_CLICKED,
		0.2
	)
	
	__ = _confetti_tween.tween_property(
		confetti_cone,
		"rect_position",
		CONFETTI_CONE_POSITION_WHEN_CLICKED,
		0.2
	)
	
	__ = _confetti_tween.chain().tween_property(
		confetti_cone,
		"rect_position",
		confetti_cone.rect_position,
		0.2
	)
	
	_confetti_tween.connect("finished", self, "_tween_completed")


func _tween_completed() -> void:
	var particles_instance = button_particles.instance()
	particles_instance.emitting = true
	particles_instance.initialize(
		confetti_particles.get_global_position() + Vector2(
			confetti_cone.rect_size.x / 4,
			confetti_cone.rect_size.y / 4
			)
	)
	add_child(particles_instance)
	
	yield(get_tree().create_timer(1), "timeout")
	
	kill_tween()
	_confetti_tween = create_tween().set_parallel()
	__ = _confetti_tween.tween_property(
		confetti_particles,
		"rect_size",
		CONFETTI_PARTICLES_ORIGINAL_SIZE,
		0.1
	)
	
	__ = _confetti_tween.tween_property(
		confetti_particles, 
		"rect_position",
		CONFETTI_PARTICLES_ORIGINAL_POSITION,
		0.1
	)


func _on_Button_mouse_exited() -> void:
	self["custom_styles/normal"].corner_radius_top_left = 30
	self["custom_styles/normal"].corner_radius_top_right = 30


func _on_Button_gui_input(p_event: InputEvent) -> void:
	if p_event is InputEventMouseMotion:
		if get_local_mouse_position().x <= rect_size.x / 2:
			self["custom_styles/normal"].corner_radius_top_left = 30 + 0.3 * get_local_mouse_position().x
			self["custom_styles/normal"].corner_radius_top_right = 30
			
		else:
			self["custom_styles/normal"].corner_radius_top_right = 30 + 0.3 * get_local_mouse_position().x
			self["custom_styles/normal"].corner_radius_top_left = 30
