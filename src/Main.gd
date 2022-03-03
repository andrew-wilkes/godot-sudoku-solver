extends Control

func _ready():
	run_tests()
	var grid = Puzzles.get_numbers()
	var possibles = []
	for i in 9:
		var row = []
		for j in 9:
			row.append(get_possible_numbers(i, j, grid))
		possibles.append(row)
	print(possibles[0])
	var rc = [0, -1]
	while true:
		rc = get_next_cell(rc, grid)
		if rc[0] == 9:
			$Label.text = "FAILED"
			break
		if eliminate(rc[0], rc[1], possibles, grid):
			break
	$GridView.update_grid(grid)


func eliminate(row, col, possibles, grid):
	if is_complete(grid): return true
	# Find a number from possible values to try
	var pvs = possibles[row][col]
	for pv in pvs:
		var poss = possibles.duplicate()
		remove_from_peers(pv, row, col, poss)
		grid[row][col] = pv
		var rc = [0, -1]
		while true:
			rc = get_next_cell(rc, grid)
			if rc[0] == 9:
				break
			if eliminate(rc[0], rc[1], poss, grid):
				return true
	grid[row][col] = 0
	return false


func remove_from_peers(n, row_index, col_index, possibles):
	remove_from_row(n, row_index, possibles)
	remove_from_col(n, col_index, possibles)
	remove_from_box(n, row_index, col_index, possibles)


func remove_from_row(n, row_index, possibles):
	for col_index in possibles.size():
		possibles[row_index][col_index].erase(n)


func remove_from_col(n, col_index, possibles):
	for row_index in possibles.size():
		possibles[row_index][col_index].erase(n)


func remove_from_box(n, row_index, col_index, possibles):
	row_index = row_index / 3 * 3
	col_index = col_index / 3 * 3
	for i in 3:
		for j in 3:
			possibles[row_index + i][col_index + j].erase(n)


func is_complete(grid):
	for i in grid.size():
		for j in grid.size():
			if grid[i][j] == 0:
				return false
	return true


func get_next_cell(rc, grid):
	var row = rc[0]
	var col = rc[1]
	while true:
		col += 1
		if col== 9:
			col = 0
			row += 1
			if row == 9:
				break
		if grid[row][col] == 0:
			break
	return [row, col]


func get_possible_numbers(row, col, grid):
	var nums = []
	var num = grid[row][col]
	if num > 0:
		 nums.append(num)
	else:
		for n in range(1, 10):
			if ok_to_place(n, row, col, grid):
				nums.append(n)
	return nums


func in_row(n, row_index, grid):
	return grid[row_index].has(n)


func in_col(n, col_index, grid):
	for row_index in grid.size():
		if grid[row_index][col_index] == n:
			return true
	return false


func in_box(n, row_index, col_index, grid):
	row_index = row_index / 3 * 3
	col_index = col_index / 3 * 3
	for i in 3:
		for j in 3:
			if grid[row_index + i][col_index + j] == n:
				return true
	return false


func ok_to_place(n, row_index, col_index, grid):
	if grid[row_index][col_index] > 0 or in_row(n, row_index, grid) or in_col(n, col_index, grid) or in_box(n, row_index, col_index, grid):
		return false
	else:
		return true


func run_tests():
	var box = [[0,1,2,0,0,0,0,0,0],[3,4,5,0,0,0,0,0,0],[0,0,9,0,0,0,0,0,0]]
	var row = [[0,1,0,0,5,0,9,2,3], [1,0,0,5,0,9,2,3,8]]
	var col = [[1,2],[8,3],[4,5]]
	assert(in_col(2, 1, col))
	assert(not in_col(8, 1, col))
	assert(in_row(9, 1, row))
	assert(not in_row(7, 0, row))
	assert(in_box(4, 2, 1, box))
	assert(not in_box(8, 2, 0, box))
	assert(ok_to_place(8, 1, 3, box))
	assert(not ok_to_place(5, 1, 3, box))
	assert(not ok_to_place(8, 1, 1, box))
	assert(get_next_cell([0, 0], box) == [0, 3])
	assert(get_next_cell([0, 8], box) == [1, 3])
	#assert(get_next_cell([8, 8], box) == [0, 0])
	assert(is_complete([[1, 1], [1, 1]]))
	assert(not is_complete([[1, 1], [0, 1]]))
	var poss = [ [[0],[1],[3,4]], [[1,2,3],[1,2],[5]], [[0],[1],[3,6]] ]
	remove_from_row(1, 1, poss)
	assert(poss[1] == [[2,3],[2],[5]])
	remove_from_col(3, 2, poss)
	assert(poss[0][2] == [4] and poss[2][2] == [6])
	box = [[[1,5,6],[2,4,5],[4,5,6]], [[1],[2],[3]], [[1],[2],[3]]]
	remove_from_box(5, 2, 2, box)
	assert(box[0] == [[1,6],[2,4],[4,6]])
	
