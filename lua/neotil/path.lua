---@class Path
local M = {}

M.__index = M

---@param path string
---@return Path
function M:new(path)
	local obj = setmetatable({}, self)

	obj.path = path

	obj._last_slash_index = 0
	obj._last_dot_index = #path + 1
	local dot_set = false
	for i = #path, 1, -1 do
		if path:sub(i, i) == "." and not dot_set then
			obj._last_dot_index = i
			dot_set = true
		elseif path:sub(i, i) == "/" then
			obj._last_slash_index = i
			break
		end
	end

	return obj
end

function M:dir()
	if self._last_slash_index == 0 then
		return nil
	elseif self._last_slash_index == 1 then
		return "/"
	end
	return self.path:sub(1, self._last_slash_index - 1)
end

function M:file()
	local file = self.path:sub(self._last_slash_index + 1)
	if file ~= "" then
		return file
	end
	return nil
end

function M:stem()
	local stem = self.path:sub(self._last_slash_index + 1, self._last_dot_index - 1)
	if stem ~= "" then
		return stem
	end
	return nil
end

function M:ext()
	local ext = self.path:sub(self._last_dot_index + 1)
	if ext ~= "" then
		return ext
	end
	return nil
end

function M:abs()
	return vim.fs.abspath(self.path)
end

return M
