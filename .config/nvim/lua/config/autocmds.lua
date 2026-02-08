-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("auto_reload_external_changes", { clear = true }),
  command = "checktime",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("disable_spell", { clear = true }),
  pattern = { "markdown", "text", "plaintex", "typst", "gitcommit" },
  callback = function()
    vim.opt_local.spell = false
  end,
})
