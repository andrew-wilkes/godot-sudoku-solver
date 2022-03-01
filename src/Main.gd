extends Control

func _ready():
	tests()


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
	if in_row(n, row_index, grid) or in_col(n, col_index, grid) or in_box(n, row_index, col_index, grid):
		return false
	else:
		return true


func tests():
	var box = [[0,1,2,0,0,0,0,0,0],[3,4,5,0,0,0,0,0,0],[0,0,9,0,0,0,0,0,0]]
	var row = [[0,1,0,0,5,0,9,2,3], [1,0,0,5,0,9,2,3,8]]
	var col = [[1,2],[8,3],[4,5]]
	assert(in_col(2, 1, col))
	assert(not in_col(8, 1, col))
	assert(in_row(9, 1, row))
	assert(not in_row(7, 0, row))
	assert(in_box(4, 2, 1, box))
	assert(not in_box(8, 2, 0, box))
