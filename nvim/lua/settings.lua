local cmd, o, b, w = vim.api.nvim_command, vim.o, vim.bo, vim.wo
local settings = {}

function settings.setup()
	-- indentation: tabs (not spaces)
	local indent = 4

	--line numbering
	w.number = true
	w.relativenumber = true
	w.cursorline = true

	-- enables mouse in all (a) modes
	o.mouse = 'a'

	-- system & nvim clipboard as one
	-- o.clipboard = 'unnamedplus'

	-- open splits below/right
	o.splitbelow = true
	o.splitright = true

	-- resume where we left off when opening a file again
	cmd([[autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]])

	-- autoformat: remove trailing whitespace on write
	cmd([[autocmd BufWritePre * %s/\s\+$//e]])

end

return settings
