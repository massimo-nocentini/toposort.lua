
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
		top[f] = nil	-- free such `f`'s stack.
		while not p:isempty() do 
			local v = p:pop()	
			count[v] = count[v] - 1
			if count[v] == 0 then append_root(v) end
		end
		f = qlink[f] 
	end

	if n > 0 then	-- a loop is detected

		qlink = {}
		--for k, _ in pairs(count) do qlink[k] = first end

		for k, _ in pairs(count) do 

			local p = top[k]
			top[k] = 0

			while p and not p:isempty() do 
				local v = p:pop()
				qlink[v] = k
			end
		end

		local w, _ = next(qlink)

		repeat
			top[w] = 1
			w = qlink[w]
		until top[w] ~= 0

		local cycle = {}
		repeat
			table.insert(cycle, w)
			top[w] = 0
			w = qlink[w]
		until top[w] ~= 1

		table.insert(cycle, w)
		
		return false, cycle

	else assert (n == 0) end

	local o = {}
	f = qlink[first]
	while f do
		table.insert(o, f)
		f = qlink[f]
	end

	return order, o

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

