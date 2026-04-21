--- Global Code Style Autocommands.
--- Defines common filetype handlers, formatting rules, and config reloading.
--- @module plugins.code_style.all

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "typescript", "tsx", "ts", "tsx", "javascript", "js" },
	callback = function()
		vim.treesitter.start()
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
	desc = "Remove option to automatically add a comment for all files.",
})
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local map_buf = function(lhs, rhs)
			vim.keymap.set("n", lhs, rhs, { buffer = args.data.buf_id })
		end
		map_buf("<Esc>", MiniFiles.close)
	end,
	desc = "Escape key closes the MiniFiles buffer.",
})
local main_config_path = vim.fn.stdpath("config") .. "/init.lua"
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("MyConfigReload", { clear = true }), -- Create or clear the augroup
	pattern = { "lua" },
	callback = function()
		print("Sourcing main init.lua...")
		vim.cmd("source " .. main_config_path)
	end,
	desc = "Source main init.lua on save",
})
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "html", "json" },
-- 	callback = function()
-- 		vim.opt_local.foldmethod = "expr"
-- 		vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- 		-- You can still set foldcolumn, foldlevel, etc., as desired
-- 	end,
-- })
vim.api.nvim_create_user_command("H", function(opts)
	vim.cmd("help " .. opts.args)
	vim.cmd("only")
end, { nargs = 1, complete = "help" })
-- Footer
-- vim:foldmethod=marker:foldlevel=1:ft=vim
