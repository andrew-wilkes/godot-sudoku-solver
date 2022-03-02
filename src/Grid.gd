extends GridContainer

func _ready():
	# Add square labels
	for n in 80:
		add_child($sq1.duplicate(), true)
	# Set number text
	var idx = 0
	for n in 3:
		for y in 3:
			for m in 3:
				for x in 3:
					get_child(idx).text = str(x + y * 3 + 1)
					idx += 1


func _draw():
	var line_color = Color.black
	var offset = 4
	var grid_size = rect_size
	var xstep = grid_size.x + 4
	var ystep = grid_size.y + 4
	draw_lines(-2, -2, xstep, ystep, 2, offset, grid_size, line_color, 4)
	xstep = grid_size.x / 3
	ystep = grid_size.y / 3
	draw_lines(xstep, ystep, xstep, ystep, 2, offset, grid_size, line_color, 2)
	xstep = grid_size.x / 9
	ystep = grid_size.y / 9
	draw_lines(xstep, ystep, xstep, ystep, 8, offset, grid_size, line_color, 1)


func draw_lines(x, y, xstep, ystep, num_reps, offset, grid_size, line_color, line_thickness):
	for n in num_reps:
		draw_line(Vector2(x, -offset), Vector2(x, grid_size.y + offset), line_color, line_thickness)
		draw_line(Vector2(-offset, y), Vector2(grid_size.x + offset, y), line_color, line_thickness)
		x += xstep
		y += ystep	
