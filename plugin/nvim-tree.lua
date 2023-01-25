-- -- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

-- empty setup using defaults
-- require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  respect_buf_cwd = true,
  -- sync_root_with_cwd = true,
  view = {
    adaptive_size = false,
    mappings = {
      list = {
        { key = "-", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
  git = {
      ignore = false,
  };
  update_focused_file = {
       enable = true,
       update_cwd = true,
       update_root = true,
  },
})

vim.keymap.set('n','<leader>e',':NvimTreeToggle<cr>')
