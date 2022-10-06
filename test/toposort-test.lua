
local toposort = require 'toposort'

local isacyclic, order = toposort.sort({ 
	[1] = {3}, 
	[3] = {7}, 
	[7] = {5, 4}, 
	[5] = {8}, 
	[4] = {6}, 
	[8] = {6}, 
	[2] = {8}, 
	[9] = {2, 5}, 
})

assert (isacyclic)
assert (table.concat(order, ', ') == '1, 9, 3, 2, 7, 4, 5, 8, 6')

local isacyclic, cycle = toposort.sort({ 
	[1] = {3}, 
	[3] = {7}, 
	[7] = {5, 4}, 
	[5] = {8}, 
	[4] = {6, 1}, -- introduces a cycle 1, 3, 7, 4, 1
	[8] = {6}, 
	[2] = {8}, 
	[9] = {2, 5}, 
})

assert (not isacyclic)
assert (table.concat(cycle, ', ') == '1, 4, 7, 3, 1')
