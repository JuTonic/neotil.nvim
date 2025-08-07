local M = {}

---@class VisualSelection
M = {}
M.__index = M

function M:get()
	local obj = setmetatable({}, self)

	local bufnr = vim.api.nvim_get_current_buf()
	obj._bufnr = bufnr

	-- https://github.com/neovim/neovim/discussions/35081
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local lines = vim.fn.getregion(s_start, s_end)

	obj.text = lines

	obj._start_row = s_start[2]
	obj._start_col = s_start[3]
	obj._end_row = s_end[2]

	if #lines == 1 then
		obj._end_col = obj._start_col + #lines[1]
	else
		obj._end_col = #lines[1]
	end

	return obj
end

function M:get_text()
	return table.concat(self.text, "\n")
end

---@param new_text string
function M:replace_with_text(new_text)
	local first_line = vim.api.nvim_buf_get_lines(self._bufnr, self._start_row - 1, self._start_row, false)[1]
	local last_line = vim.api.nvim_buf_get_lines(self._bufnr, self._end_row - 1, self._end_row, false)[1]
	local first_line_before_selection = first_line:sub(1, self._start_col - 1)
	local last_line_after_selection = last_line:sub(self._end_col)

	local replacement =
		vim.split(first_line_before_selection .. new_text .. last_line_after_selection, "\n", { plain = true })

	vim.api.nvim_buf_set_lines(self._bufnr, self._start_row - 1, self._end_row, false, replacement)
end

return M
