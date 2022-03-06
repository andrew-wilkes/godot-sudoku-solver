extends Control

func _ready():
	run_tests()
	var grid = Puzzles.get_numbers()
	$GridView.update_grid(grid)
	var possibles = []
	for i in 9:
		var row = []
		for j in 9:
			row.append(get_possible_numbers(i, j, grid))
		possibles.append(row)
	print(possibles[0])
	var start = OS.get_system_time_msecs()
	# Start solving where the initial cell to be tried will be 0,0
	solve(0, -1, possibles, grid)
	prints("Time:", OS.get_system_time_msecs() - start, "ms")
	$GridView.update_grid(grid)


func solve(row, col, possibles, grid):
	if is_complete(grid):
		return true
	# Find the next cell with the least number of possible values
	# This speeds up the solution resolution by around 7 x
	var empty_cells = []
	var cells = {}
	while true:
		var rc = get_next_cell(row, col, grid)
		if empty_cells.has(rc):
			break
		empty_cells.append(rc)
		# There is a big speed impact if we don't do this for the index values
		row = rc[0]
		col = rc[1]
		var pvs = possibles[row][col]
		cells[pvs.size()] = rc
	# Get it
	var rc = cells[cells.keys().min()]
	row = rc[0]
	col = rc[1]
	# There is no speed benefit to store this value that was previously got
	var pvs = possibles[row][col]
	for pv in pvs:
		grid[row][col] = pv
		# There is a possible performance optimization to be made here by using a string of numbers rather than an array
		var poss = possibles.duplicate(true)
		remove_from_peers(pv, row, col, poss)
		if solve(row, col, poss, grid):
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


func get_next_cell(row, col, grid):
	while true:
		col += 1
		if col== 9:
			col = 0
			row += 1
			if row == 9:
				row = 0
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
	if grid[row_index][col_index] > 0 \
		or in_row(n, row_index, grid) \
		or in_col(n, col_index, grid) \
		or in_box(n, row_index, col_index, grid):
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
	assert(get_next_cell(0, 0, box) == [0, 3])
	assert(get_next_cell(0, 8, box) == [1, 3])
	assert(get_next_cell(8, 8, box) == [0, 0])
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
