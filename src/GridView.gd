extends MarginContainer

func update_grid(rows, fresh = true):
	var idx = 0
	for row in rows:
		for number in row:
			var cell = $Grid.get_child(idx)
			if number == 0:
				cell.text = ""
				cell.modulate = Color.green
			else:
				cell.text = str(number)
				if fresh: cell.modulate = Color.white
			idx += 1


func _ready():
	pass
	#test()


func test():
	update_grid(Puzzles.get_numbers())
