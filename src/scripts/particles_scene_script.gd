extends CPUParticles2D

var _particles_tween: SceneTreeTween
var _resize_tween: SceneTreeTween
var _position: Vector2
var __
var scale_factor = 0.05


func _ready() -> void:
	set_global_position(_position)
	yield(get_tree().create_timer(0.05), "timeout")
	_increase_gravity_and_reduce_a()


func initialize(p_position: Vector2) -> void:
	_position = p_position


func _increase_gravity_and_reduce_a() -> void:
	if is_instance_valid(_particles_tween):
		_particles_tween.stop()
		_particles_tween.kill()
	
	gravity.y = 120
	_particles_tween = create_tween()
	__ = _particles_tween.chain().tween_property(self, "color:a", 0, 1.8)
	
	yield(_particles_tween, "finished")
	queue_free() 
