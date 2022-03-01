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
	var x = -2
	var y = -2
	for n in 2:
		draw_line(Vector2(x, -offset), Vector2(x, grid_size.y + offset), line_color, 4)
		draw_line(Vector2(-offset, y), Vector2(grid_size.x + offset, y), line_color, 4)
		x += xstep
		y += ystep	
	xstep = grid_size.x / 3
	ystep = grid_size.y / 3
	x = xstep
	y = ystep
	for n in 2:
		draw_line(Vector2(x, -offset), Vector2(x, grid_size.y + offset), line_color, 2)
		draw_line(Vector2(-offset, y), Vector2(grid_size.x + offset, y), line_color, 2)
		x += xstep
		y += ystep
	xstep = grid_size.x / 9
	ystep = grid_size.y / 9
	x = xstep
	y = ystep
	for n in 8:
		draw_line(Vector2(x, -offset), Vector2(x, grid_size.y + offset), line_color, 1)
		draw_line(Vector2(-offset, y), Vector2(grid_size.x + offset, y), line_color, 1)
		x += xstep
		y += ystep
