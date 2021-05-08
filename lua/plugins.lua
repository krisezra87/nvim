return require('packer').startup(function()

    -- Manage packer itself
    use {'wbthomason/packer.nvim', opt=true}

    use {'ulwlu/elly.vim'}
    use {'tpope/vim-fugitive'}
    use {'junegunn/fzf',dir = '~/.fzf',run = './install --all'}
    use {'junegunn/fzf.vim'}

end)
