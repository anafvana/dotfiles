local g = vim.g
local map = vim.api.nvim_set_keymap
local n = { noremap = true }
local ns = { noremap = true, silent = true }
local keys = {}

function keys.setup()
	g.mapleader = " "

	-- autocomplete find & replace
	map('n', 'S', ':%s//gc<Left><Left><Left>', n)

	-- clear highlights
	map('n', '<Leader>x', ':noh<CR>', n)
end

return keys
