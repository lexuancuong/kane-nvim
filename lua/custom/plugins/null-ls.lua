local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
  -- black, isort, autopep8 must to be installed successfully in the environment
  -- you could use this PATH=$HOME/.local/bin:$PAHT to let the environment know
  -- what is the black, isort, autopep8 and other python packages
  b.formatting.black,
  b.formatting.isort,
  b.formatting.autopep8,
  b.completion.spell,
  b.formatting.trim_newlines,
  b.formatting.trim_whitespace,
}

local M = {}

M.setup = function()
   null_ls.setup {
      debug = true,
      sources = sources,
   }
end

return M
