
-- This is an implementation of Knuth's Algorithm T.

local linkedpool = require 'linkedpool'
local linkedstack = require 'linkedstack'

local toposort = {}

function toposort.sort(rel)

	local pool = linkedpool.create ()
	local count, top, n, zero = {}, {}, 0, 0

	for requirement, dependants in pairs(rel) do

		if not count[requirement] then
			--print('requirement ' .. tostring(requirement))
			count[requirement] = zero
			top[requirement] = linkedstack.create (pool)
			n = n + 1
		end

		for _, dependant in ipairs(dependants) do

			if not count[dependant] then
				--print('dependant ' .. tostring(dependant))
				count[dependant] = zero
				top[dependant] = linkedstack.create (pool)
				n = n + 1
			end

			count[dependant] = count[dependant] + 1

			top[requirement]:push (dependant)	-- record the relation
		end
	end

	local qlink, first = {}, {}
	local r = first
	for k, c in pairs(count) do
		if c == zero then 
			qlink[r] = k
			r = k
		end
	end

	local order = {}
	f = qlink[first]	-- `f` is the first value encountered  for which `count[k] == 0` holds.

	--for k, v in pairs(qlink) do print(k, v) end

	while f do
		table.insert(order, f)
		
		n = n - 1
		local p = top[f]
		while not p:isempty() do 
			local v = p:pop()	
			count[v] = count[v] - 1
			if count[v] == 0 then 
				qlink[r] = v	-- the value of `r` is the one left in the outer loop.
				r = v
			end
		end
		f = qlink[f] 
	end

	assert (n == 0)

	return order
end


return toposort

