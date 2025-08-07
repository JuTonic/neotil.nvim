local M = {}

M.brackets = {}

M.brackets.type = {
	CURLY = { opening = "{", closing = "}" },
	SQUARE = { opening = "[", closing = "]" },
	ROUND = { opening = "(", closing = ")" },
}

---@param line string
---@param col integer
---@param bracket_pair BracketPair
---@param target_depth? integer
function M.brackets.match(line, col, bracket_pair, target_depth)
	target_depth = target_depth or 1
	local opening, closing = bracket_pair.opening, bracket_pair.closing
	local depth = -target_depth

	local cursor_char = line:sub(col, col)
	if cursor_char == closing then
		depth = depth + 1
	end

	local start_col
	for i = col, 1, -1 do
		local char = line:sub(i, i)
		if char == opening then
			depth = depth + 1
		elseif char == closing then
			depth = depth - 1
		end
		print(char, depth)
		if depth == 0 then
			start_col = i
			break
		end
	end
	if not start_col then
		print("here")
		return
	end

	depth = target_depth
	if cursor_char == opening then
		depth = depth - 1
	end

	local end_col
	for i = col, #line do
		local char = line:sub(i, i)
		if char == opening then
			depth = depth + 1
		elseif char == closing then
			depth = depth - 1
		end
		if depth == 0 then
			end_col = i
			break
		end
	end
	if not end_col then
		return
	end

	return line:sub(start_col + 1, end_col - 1)
end

return M
