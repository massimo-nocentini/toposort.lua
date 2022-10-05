
local toposort = require 'toposort'

local order, o = toposort.sort({ 
	[1] = {3}, 
	[3] = {7}, 
	[7] = {5, 4}, 
	[5] = {8}, 
	[4] = {6}, 
	[8] = {6}, 
	[2] = {8}, 
	[9] = {2, 5}, 
})

assert (table.concat(order, ', ') == '1, 9, 3, 2, 7, 4, 5, 8, 6')
assert (table.concat(o, ', ') == '1, 9, 3, 2, 7, 4, 5, 8, 6')

local flag, cycle = toposort.sort({ 
	[1] = {3}, 
	[3] = {7}, 
	[7] = {5, 4}, 
	[5] = {8}, 
	[4] = {6, 1}, -- introduces a cycle 1, 3, 7, 4, 1
	[8] = {6}, 
	[2] = {8}, 
	[9] = {2, 5}, 
})

assert (not flag)

print(table.concat(cycle, ', '))
