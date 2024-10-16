extends CPUParticles2D

var color_1: Color = Color(0.14, 0.07, 0.16, 1.0)
var color_2: Color = Color(0.30, 0.14, 0.16, 1.0)
var color_3: Color = Color(0.98, 0.69, 0.37, 1.0)
var color_4: Color = Color(0.99, 0.93, 0.57, 1.0)


func _ready() -> void:
	$Timer.wait_time = lifetime / speed_scale
	$Timer.start()

	var m_colors: Array = [color_1, color_2, color_3, color_4]
	var new_color: Color
	var m_offset_array: Array = []
	var new_offset: float = 0.0
	var m_offset_value: float = 1.0 / amount
	
	for _i in range(amount-4):
		new_color = m_colors[int(rand_range(0,4))]
		new_color.a = rand_range(0,1)
		new_color.r += (rand_range(-0.15,0.15))
		new_color.g += (rand_range(-0.15,0.15))
		new_color.b += (rand_range(-0.15,0.15))
		m_colors.append(new_color)
		
	color_initial_ramp.colors = m_colors

	for _i in range(amount):
		new_offset += m_offset_value
		m_offset_array.append(new_offset)

	color_initial_ramp.offsets = m_offset_array


func _on_Timer_timeout():
	queue_free()
