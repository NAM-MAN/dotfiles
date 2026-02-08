-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.opt.autoread = true

-- mise shims force GOBIN to mise's install dir, breaking Mason's go install.
-- Use real binary paths instead so Mason can set GOBIN to its own package dir.
local mise_installs = vim.fn.expand("~/.local/share/mise/installs")
local mise_paths = {}
for _, entry in ipairs(vim.fn.readdir(mise_installs)) do
  local tool_dir = mise_installs .. "/" .. entry
  for _, ver in ipairs(vim.fn.readdir(tool_dir)) do
    local bin_dir = tool_dir .. "/" .. ver .. "/bin"
    if vim.fn.isdirectory(bin_dir) == 1 then
      table.insert(mise_paths, bin_dir)
    elseif vim.fn.isdirectory(tool_dir .. "/" .. ver) == 1 then
      table.insert(mise_paths, tool_dir .. "/" .. ver)
    end
  end
end
vim.env.PATH = table.concat(mise_paths, ":") .. ":" .. vim.env.PATH
vim.env.GOBIN = nil
