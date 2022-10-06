
-- This is an implementation of Knuth's Algorithm T.

local linkedpool = require 'linkedpool'
local linkedstack = require 'linkedstack'

local toposort = {}

local zero = 0

local function T (n, count, top)

	local qlink, first = {}, {}

	local r = first		-- this is a *very* important variable.

	local function append_root (k) 
		qlink[r] = k
		r = k
	end

	for k, c in pairs(count) do if c == zero then append_root(k) end end

	local order = {}

	f = qlink[first]	-- `f` is the first value encountered  for which `count[k] == 0` holds.

	while f do
		table.insert(order, f)
		
		n = n - 1
		local p = top[f]

		while not p:isempty() do 
			local v = p:pop()	
			count[v] = count[v] - 1
			if count[v] == 0 then append_root(v) end
		end
		f = qlink[f] 
	end

	if n > 0 then	-- a loop is detected

		qlink = {}

		for k, _ in pairs(count) do 

			local p = top[k]
			top[k] = false

			while not p:isempty() do 
				local v = p:pop()
				qlink[v] = k
			end
		end

		local w, _ = next(qlink)

		repeat
			top[w] = true
			w = qlink[w]
		until top[w]

		local cycle = {}
		repeat
			table.insert(cycle, w)
			top[w] = false
			w = qlink[w]
		until not top[w]

		table.insert(cycle, w)
		
		return false, cycle

	elseif n == 0 then return true, order 
	else error 'Logical error: too many deletion' end

end

function toposort.sort(rel)

	local pool = linkedpool.create ()
	local count, top, n = {}, {}, 0

	for requirement, dependants in pairs(rel) do

		if not count[requirement] then
			count[requirement] = zero
			top[requirement] = linkedstack.create (pool)
			n = n + 1
		end

		for _, dependant in ipairs(dependants) do

			if not count[dependant] then
				count[dependant] = zero
				top[dependant] = linkedstack.create (pool)
				n = n + 1
			end

			count[dependant] = count[dependant] + 1

			top[requirement]:push (dependant)	-- record the relation
		end
	end

	return T (n, count, top)
end


return toposort

