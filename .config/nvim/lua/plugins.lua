local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
	-- packer itself
	use 'wbthomason/packer.nvim'

  	-- lsp
	use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client

	-- autoclose brackets, quotes, etc
	use 'tmsvg/pear-tree'

	-- move lines/blocks of code
	use 'booperlv/nvim-gomove'

	-- colour picking and displaying
	use 'KabbAmine/vCoolor.vim'
	-- use 'chrisbra/colorizer'
	use {'rrethy/vim-hexokinase', run = 'cd ~/.local/share/nvim/site/pack/packer/start/vim-hexokinase && make hexokinase'}

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end)
