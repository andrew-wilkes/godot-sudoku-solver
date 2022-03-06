extends Node

# Tests

static func run(target):
	var box = [[0,1,2,0,0,0,0,0,0],[3,4,5,0,0,0,0,0,0],[0,0,9,0,0,0,0,0,0]]
	var row = [[0,1,0,0,5,0,9,2,3], [1,0,0,5,0,9,2,3,8]]
	var col = [[1,2],[8,3],[4,5]]
	assert(target.in_col(2, 1, col))
	assert(not target.in_col(8, 1, col))
	assert(target.in_row(9, 1, row))
	assert(not target.in_row(7, 0, row))
	assert(target.in_box(4, 2, 1, box))
	assert(not target.in_box(8, 2, 0, box))
	assert(target.ok_to_place(8, 1, 3, box))
	assert(not target.ok_to_place(5, 1, 3, box))
	assert(not target.ok_to_place(8, 1, 1, box))
	assert(target.get_next_cell(0, 0, box) == [0, 3])
	assert(target.get_next_cell(0, 8, box) == [1, 3])
	assert(target.get_next_cell(8, 8, box) == [0, 0])
	assert(target.is_complete([[1, 1], [1, 1]]))
	assert(not target.is_complete([[1, 1], [0, 1]]))
	var poss = [ [[0],[1],[3,4]], [[1,2,3],[1,2],[5]], [[0],[1],[3,6]] ]
	target.remove_from_row(1, 1, poss)
	assert(poss[1] == [[2,3],[2],[5]])
	target.remove_from_col(3, 2, poss)
	assert(poss[0][2] == [4] and poss[2][2] == [6])
	box = [[[1,5,6],[2,4,5],[4,5,6]], [[1],[2],[3]], [[1],[2],[3]]]
	target.remove_from_box(5, 2, 2, box)
	assert(box[0] == [[1,6],[2,4],[4,6]])
