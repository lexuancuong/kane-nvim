local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
  b.formatting.black,
  b.formatting.isort,
  b.formatting.autopep8,
  b.completion.spell,
}

local M = {}

M.setup = function()
   null_ls.setup {
      debug = true,
      -- sources = sources,
   }
end

return M
