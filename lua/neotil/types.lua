---@class Path
---@field path string
---@field _last_slash_index integer
---@field _last_dot_index integer
---@field new fun(self: Path, path: string): Path
---@field dir fun(self: Path): string?
---@field file fun(self: Path): string?
---@field stem fun(self: Path): string?
---@field ext fun(self: Path): string?

---@class VisualSelection
---@field _bufnr integer
---@field _start_row integer
---@field _start_col integer
---@field _end_row integer
---@field _end_col integer
---@field text string[]

---@class BracketPair
---@field opening string
---@field closing string

---@class EnviromentMatch
---@field name string
---@field content string[]
---@field start_line integer
---@field end_line integer
