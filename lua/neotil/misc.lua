local M = {}

--- see https://neovim.discourse.group/t/get-path-to-plugin-directory/2658
--- Get the root path of the plugin. Put in debug.getinfo(1, "S")
---@param info debuginfo
---@param plugin_name? string
---@return string
function M.get_plugin_root_path(info)
	local script_path = info.source:sub(2)
	local root = vim.fn.fnamemodify(script_path, ":h:h:h")
	return root
end

---@param plugin_name? string
---@return string
function M.get_data_dir(plugin_name)
	local data_dir = vim.fn.stdpath("data")
	if plugin_name then
		data_dir = vim.fs.joinpath(data_dir, plugin_name)
	end
	vim.fn.mkdir(data_dir, "p")
	return data_dir
end

return M
