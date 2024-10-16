extends Control


export(PackedScene) var particles


func _ready():
	randomize()


func _on_Spread_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var m_particles = particles.instance()
			m_particles.position = get_global_mouse_position()
			m_particles.emitting = true
			add_child(m_particles)
