return require('packer').startup(function()
    -- Manage packer itself
    use {'wbthomason/packer.nvim', opt=true}

    -- use {'ulwlu/elly.vim'}
    use {'shaunsingh/nord.nvim'}

    use {'tpope/vim-fugitive'}
    use {'junegunn/fzf',dir = '~/.fzf',run = './install --all'}
    use {'ibhagwan/fzf-lua'}
    -- use {'junegunn/fzf.vim'}

    -- Core functionality
    use {'markonm/traces.vim'}
    use {'tomtom/tcomment_vim'}
    use {'tpope/vim-surround'}
    use {'chaoren/vim-wordmotion'}
    use {'unblevable/quick-scope'}
    use {'wellle/targets.vim'}
    -- Make indentations vim objects
    use {'michaeljsmith/vim-indent-object'}
    use {'tommcdo/vim-lion'}
    use {'airblade/vim-rooter'}
    -- Show indentation line markers
    use {'lukas-reineke/indent-blankline.nvim'}
    -- Context-aware pasting.  Paste with correct local indents
    use {'sickill/vim-pasta'}
    -- Identify whitespace and strip on save
    use {'ntpeters/vim-better-whitespace'}

    -- vimwiki
    use {'vimwiki/vimwiki'}
    -- Task Wiki Integration (Requires vimwiki)
    -- use {'tools-life/taskwiki'}

    -- Repeat enabled for . on plugin mappings (Surround.vim)
    use {'tpope/vim-repeat'}

    -- Better integration with tmux
    -- use {'christoomey/vim-tmux-navigator'}

    -- Better usage and compiling of LaTeX
    -- This does syntax stuff, maybe use treesitter here
    -- instead?
    use {'lervag/vimtex'}

    -- use {'SirVer/ultisnips', opt = true, cmd = {'UltiSnips#ExpandSnippetOrJump','UltiSnipsEdit'}}
    use {'SirVer/ultisnips'}
    use {'honza/vim-snippets'}

    -- Tree Sitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- -- Nvim cmp for completion
    use {'neovim/nvim-lspconfig'}
    use {'hrsh7th/cmp-nvim-lsp'}
    use {'hrsh7th/cmp-nvim-lsp-signature-help'}
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-path'}
    use {'hrsh7th/cmp-cmdline'}
    use {'hrsh7th/nvim-cmp'}
    use {'quangnguyen30192/cmp-nvim-ultisnips'}

    -- Debugging
    use {'mfussenegger/nvim-dap'}
    use {'nvim-tree/nvim-web-devicons'}
    use {'rcarriga/nvim-dap-ui'}
    use {'theHamsta/nvim-dap-virtual-text'}
    use {'rcarriga/cmp-dap'}
    use {'mfussenegger/nvim-dap-python'}

    -- Tags
    use {'majutsushi/tagbar'}
    -- use {'mbbill/undotree'}

    -- Show colors of hex codes
    use {'chrisbra/Colorizer'}

    -- Give nice popups for git things
    use {'rhysd/git-messenger.vim'}

    -- Ripgrep integration
    use {'jremmen/vim-ripgrep'}

    -- For markdown previews
    use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}

    -- For LSP
    use {'neomake/neomake'}

    -- For doing nice window sizing based on activity

    use { "anuvyklack/windows.nvim",
    requires = {
        "anuvyklack/middleclass",
        "anuvyklack/animation.nvim"
    },
    config = function()
        vim.o.winwidth = 10
        vim.o.winminwidth = 10
        vim.o.equalalways = false
        require('windows').setup()
    end
    }
end)
