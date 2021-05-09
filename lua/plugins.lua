return require('packer').startup(function()

    -- Manage packer itself
    use {'wbthomason/packer.nvim', opt=true}

    use {'ulwlu/elly.vim'}
    use {'tpope/vim-fugitive'}
    use {'junegunn/fzf',dir = '~/.fzf',run = './install --all'}
    use {'junegunn/fzf.vim'}

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
    use {'Yggdroot/indentLine'}
    use {'lukas-reineke/indent-blankline.nvim'}
    -- Context-aware pasting.  Paste with correct local indents
    use {'sickill/vim-pasta'}
    -- Identify whitespace and strip on save
    use {'ntpeters/vim-better-whitespace'}

    -- vimwiki
    use {'vimwiki/vimwiki'}
    -- Task Wiki Integration (Requires vimwiki)
    use {'tools-life/taskwiki'}

    -- Repeat enabled for . on plugin mappings (Surround.vim)
    use {'tpope/vim-repeat'}

    -- Better integration with tmux
    use {'christoomey/vim-tmux-navigator'}

    -- Better usage and compiling of LaTeX
    -- This does syntax stuff, maybe use treesitter here
    -- instead?
    use {'lervag/vimtex'}

    -- use {'SirVer/ultisnips', opt = true, cmd = {'UltiSnips#ExpandSnippetOrJump','UltiSnipsEdit'}}
    use {'SirVer/ultisnips'}
    use {'honza/vim-snippets'}

    -- Tree Sitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {'nvim-treesitter/playground'}
    -- Python debugger
    -- use {'puremourning/vimspector'}

    -- use {'neoclide/coc.nvim'}, {'branch': 'release'}
    -- use {'neoclide/vim-node-rpc'}
    -- use {'majutsushi/tagbar'}
    -- use {'tommcdo/vim-exchange'}
    -- use {'mbbill/undotree'}
    -- use {'djoshea/vim-matlab-fold'}

    -- Show colors of hex codes
    -- use {'chrisbra/Colorizer'}
end)
