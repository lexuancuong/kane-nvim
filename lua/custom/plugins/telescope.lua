-- Implement delta as previewer for diffs

local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local builtin = require('telescope.builtin')
local M = {}

M.my_git_status = function(opts)
  opts = opts or {}
  -- opts.previewer = delta
  opts.previewer = previewers.new_termopen_previewer({
    get_command = function(entry)
      if entry.status == "D" then
        return { "git", "show", "HEAD:" .. entry.value }
      elseif entry.status == "??" then
        return { "batcat", "--style=plain", entry.value }
      end
      return {
        "git", "-c", "core.pager=delta", "-c", "delta.pager=less -R", "diff", entry.value,
      }
    end,
    previewers.git_file_diff.new(opts),
  })

  -- Use icons that resemble the `git status` command line.
  opts.git_icons = {
    added = "A",
    changed = "M",
    copied = "C",
    deleted = "-",
    renamed = "R",
    unmerged = "U",
    untracked = "?",
  }

  builtin.git_status(opts)
end

return M 
