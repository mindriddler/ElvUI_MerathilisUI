local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local pairs, next, type, select, unpack = pairs, next, type, select, unpack
local tinsert, tsort = table.insert, table.sort
local setmetatable = setmetatable

F.Table = {}

function F.Table.Print(tbl, indent)
	if not indent then
		indent = 0
	end

	local formatting
	for k, v in pairs(tbl) do
		formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			F.TablePrint(v, indent + 1)
		elseif type(v) == "boolean" then
			print(formatting .. tostring(v))
		else
			print(formatting .. v)
		end
	end
end

function F.Table.SetMetatables(tbl, mt)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			tbl[k] = F.Table.SetMetatables(v, mt)
		end
	end

	return setmetatable(tbl, mt)
end

function F.Table.IsEmpty(tbl)
	return next(tbl) == nil
end

function F.Table.HasAnyEntries(tbl)
	return not F.Table.IsEmpty(tbl)
end

function F.Table.GetOrCreate(tbl, ...)
	local currentTable = tbl

	for i = 1, select("#", ...) do
		local key = (select(i, ...))
		if type(currentTable[key]) ~= "table" then
			currentTable[key] = {}
		end
		currentTable = currentTable[key]
	end

	return currentTable
end

function F.Table.RemoveEmpty(tbl)
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			if next(v) == nil then
				tbl[k] = nil
			else
				tbl[k] = F.Table.RemoveEmpty(v)
			end
		end
	end

	return tbl
end

function F.Table.Join(...)
	local ret = {}

	for i = 1, select("#", ...) do
		local t = select(i, ...)
		if t then
			for k, v in pairs(t) do
				if type(k) == "number" then
					tinsert(ret, v)
				else
					ret[k] = v
				end
			end
		end
	end

	return ret
end