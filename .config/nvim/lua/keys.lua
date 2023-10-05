local g = vim.g
local map = vim.api.nvim_set_keymap
local n = { noremap = true }
local ns = { noremap = true, silent = true }
local keys = {}

function keys.setup()
	g.mapleader = " "
	g.maplocalleader = ","

	-- autocomplete find & replace
	map('n', 'S', ':%s///gc<Left><Left><Left><Left>', n)
	map('n', 's', ':X,Ys///gc<Left><Left><Left><Left><Left><Left><Left><Left><Left>', n)

	-- clear highlights
	map('n', '<Leader>x', ':noh<CR>', n)

	-- LSP mappings
	-- LSP: diagnostic
	local opts = { noremap=true, silent=true }
	map('n', '<Leader>f', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	map('n', '<Leader>N', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	map('n', '<Leader>n', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	map('n', '<Leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
end

return keys
