extends Control

var numbers
var unsolved = true
var tests = preload("res://tests.gd")

func _ready():
	tests.run(self)
	init_grid()
	OS.window_size = $VBox.rect_size


func init_grid():
	numbers = Puzzles.get_numbers()
	$VBox/GridView.update_grid(numbers)


func run():
	var possibles = []
	for i in 9:
		var row = []
		for j in 9:
			row.append(get_possible_numbers(i, j, numbers))
		possibles.append(row)
	print(possibles[0])
	var start = OS.get_system_time_msecs()
	# Start solving where the initial cell to be tried will be 0,0
	solve(0, -1, possibles, numbers)
	$VBox/Time.text = "Time: " + str(OS.get_system_time_msecs() - start) + "ms"
	$VBox/GridView.update_grid(numbers, false)


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


func _on_Solve_pressed():
	if unsolved:
		$VBox/Solve.text = "Refresh"
		run()
	else:
		$VBox/Solve.text = "Solve"
		$VBox/Time.text = ""
		init_grid()
	unsolved = !unsolved
