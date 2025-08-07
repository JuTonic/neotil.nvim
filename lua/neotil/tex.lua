local M = {}

M.enviroments = {
	FIGURE = "figure",
}

local NOT_INSTALLED_MSG = "vimtex is not installed"

---@param name string enviroment name
function M.in_env(name)
	local ok, is_inside = pcall(vim.fn["vimtex#env#is_inside"], name)

	if not ok then
		vim.notify(NOT_INSTALLED_MSG, vim.log.levels.WARN)
		return
	end

	return (is_inside[1] > 0 and is_inside[2] > 0)
end

---@return boolean
function M.in_mathzone()
	local ok, is_inside = pcall(vim.fn["vimtex#syntax#in_mathzone"])

	if not ok then
		vim.notify(NOT_INSTALLED_MSG, vim.log.levels.WARN)
		return false
	end

	return is_inside == 1
end

---@param name string
---@param lines string[]
---@param cursor_row integer
---@param target_depth integer? default = 1
---@return EnviromentMatch?
function M.match_env(name, lines, cursor_row, target_depth)
	target_depth = target_depth or 1
	local match_begin = "\\begin%s*{%s*" .. name .. "%s*}%s*.*$"
	local match_end = "\\end%s*{%s*" .. name .. "%s*}%s*.*$"

	local depth = -target_depth

	local start_line

	local cursor_line = lines[cursor_row]
	if cursor_line:match(match_begin) then
		depth = depth - 1
	end

	for i = cursor_row, 1, -1 do
		local line = lines[i]
		if line:match(match_begin) then
			depth = depth + 1
		elseif line:match(match_end) then
			depth = depth - 1
		end
		if depth == 0 then
			start_line = i
			break
		end
	end
	if not start_line then
		return
	end

	depth = target_depth
	if cursor_line:match(match_end) then
		depth = depth + 1
	end

	local end_line
	for i = cursor_row, #lines do
		local line = lines[i]
		if line:match(match_begin) then
			depth = depth + 1
		elseif line:match(match_end) then
			depth = depth - 1
		end
		if depth == 0 then
			end_line = i
			break
		end
	end
	if not end_line then
		return
	end

	---@type string[]
	local content = {}
	for i = start_line + 1, end_line - 1 do
		table.insert(content, lines[i])
	end
	return {
		name = name,
		content = content,
		start_line = start_line,
		end_line = end_line,
	}
end

return M
