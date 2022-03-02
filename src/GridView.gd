extends MarginContainer

func update_grid(rows):
	var idx = 0
	for row in rows:
		for number in row:
			$Grid.get_child(idx).text = "" if number == 0 else str(number)
			idx += 1


func _ready():
	pass
	#test()


func test():
	update_grid(Puzzles.get_numbers())
