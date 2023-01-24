local setup = function()
	require'plugins'
	require'keys'.setup()
	require'settings'.setup()
	require("mason").setup({
    	PATH = "prepend",
	})
end

setup()
