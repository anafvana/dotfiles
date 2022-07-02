local cmd, au, o, b, w = vim.api.nvim_command, vim.api.nvim_create_autocmd, vim.o, vim.bo, vim.wo
local settings = {}

function settings.setup()
	-- indentation: tabs (not spaces)
	local indent = 4
	b.shiftwidth = indent
	o.shiftwidth = indent
	b.tabstop = indent
	o.tabstop = indent

	-- gui colours
	o.termguicolors=true

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

	-- colourise colour codes
	cmd([[autocmd BufEnter *.html,*.css,*.scss,*.js,*.jsx,*.ts,*.tsx,*.json,*.tex,*.cls :HexokinaseTurnOn]])
	-- with Colorize
	-- cmd([[autocmd BufEnter *.html,*.css,*.scss,*.js,*.jsx,*.ts,*.tsx,*.json :ColorHighlight]])
	au("BufWritePost", {
        pattern = "*.tex,*.cls",
        command = "!pdflatex main.tex"
    })

	require "lspconfig".efm.setup {
		init_options = {documentFormatting = true},
		settings = {
			rootMarkers = {".git/"},
			languages = {
				-- lua = {
				-- {formatCommand = "lua-format -i", formatStdin = true}
				-- }
				sh = {
					{
						lintCommand = 'shellcheck -f gcc -x',
						lintSource = 'shellcheck',
						lintFormats = {
							'%f:%l:%c: %trror: %m',
							'%f:%l:%c: %tarning: %m',
							'%f:%l:%c: %tote: %m'
						}
					}
				}
			}
		}
	}

	require("gomove").setup {
		-- whether or not to map default key bindings, (true/false)
		map_defaults = true,
		-- whether or not to reindent lines moved vertically (true/false)
		reindent = true,
		-- whether or not to undojoin same direction moves (true/false)
		undojoin = true,
		-- whether to not to move past end column when moving blocks horizontally, (true/false)
		move_past_end_col = false,
	}
end

return settings
