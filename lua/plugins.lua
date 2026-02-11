-- Example: lua/plugins.lua or in your init.lua
require("lazy").setup({
  -- Manage lazy itself (packer self-management is no longer needed)

  -- Colorscheme
  { "shaunsingh/nord.nvim" },

  -- Git / FZF
  { "tpope/vim-fugitive" },
  { "junegunn/fzf", build = "echo 'Skipping fzf install'" },
  { "ibhagwan/fzf-lua" },

  -- Core functionality
  { "markonm/traces.vim" },
  { "tomtom/tcomment_vim" },
  { "tpope/vim-surround" },
  { "chaoren/vim-wordmotion" },
  { "unblevable/quick-scope" },
  { "wellle/targets.vim" },
  { "michaeljsmith/vim-indent-object" },
  { "tommcdo/vim-lion" },
  { "airblade/vim-rooter" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "sickill/vim-pasta" },
  { "ntpeters/vim-better-whitespace" },

  -- vimwiki
  { "vimwiki/vimwiki" },
  -- { "tools-life/taskwiki" }, -- commented out like original

  -- Repeat for plugin mappings
  { "tpope/vim-repeat" },

  -- Tmux integration
  { "christoomey/vim-tmux-navigator" },

  -- LaTeX
  { "lervag/vimtex" },

  -- Snippets
  { "SirVer/ultisnips" },
  { "honza/vim-snippets" },

  -- Treesitter
{
  "nvim-treesitter/nvim-treesitter",
  -- build = ":TSUpdate",
  config = function()
    require'nvim-treesitter.configs'.setup {
      -- ensure_installed = {"python","bash","bibtex","regex","vim","json","json5","toml"},
      sync_install = false,
      auto_install = false,
      ignore_install = {"latex"},
      highlight = {
        enable = true,
        disable = {'latex', 'lua'},
      },
    }
  end,
},

  -- LSP / completion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/nvim-cmp" },
  { "quangnguyen30192/cmp-nvim-ultisnips" },
  { "folke/neodev.nvim" },

  -- Debugging
  { "nvim-neotest/nvim-nio" },
  { "mfussenegger/nvim-dap" },
  { "nvim-tree/nvim-web-devicons" },
  { "rcarriga/nvim-dap-ui" },
  { "theHamsta/nvim-dap-virtual-text" },
  { "rcarriga/cmp-dap" },
  { "mfussenegger/nvim-dap-python" },

  -- Tags / undo tree
  { "majutsushi/tagbar" },
  { "mbbill/undotree" },

  -- Colors / git helpers / ripgrep
  { "chrisbra/Colorizer" },
  { "rhysd/git-messenger.vim" },
  { "jremmen/vim-ripgrep" },

  -- Markdown preview
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install" },

  -- Neomake (LSP/linters)
  { "neomake/neomake" },

  -- Window management (with dependencies and config)
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require("windows").setup()
    end,
  },

  -- Nvim-tree (with dependency)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
})
