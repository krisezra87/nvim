return require('packer').startup(function()

    -- Manage packer itself
    use {'wbthomason/packer.nvim', opt=true}

    use {'ulwlu/elly.vim'}
    use {'tpope/vim-fugitive'}

end)
