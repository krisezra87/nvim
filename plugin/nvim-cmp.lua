-- Set up lspconfig capabilities.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require'lspconfig'.pyright.setup{
    capabilities = capabilities,
    on_attach = function() -- run this code on attach to lsp
        vim.keymap.set('n','K',vim.lsp.buf.hover,{buffer=0}) -- assign only for this buffer
        vim.keymap.set('n','gd',vim.lsp.buf.definition,{buffer=0}) -- assign only for this buffer
        vim.keymap.set('n','gr',vim.lsp.buf.references,{buffer=0}) -- assign only for this buffer
        vim.keymap.set('n','<leader>en',vim.diagnostic.goto_next,{buffer=0}) -- jump to next error
        vim.keymap.set('n','<leader>ep',vim.diagnostic.goto_prev,{buffer=0}) -- jump to prev error
        vim.keymap.set('n','<leader>r',vim.lsp.buf.rename,{buffer=0}) -- rename a variable
        vim.keymap.set('n','<leader>up',vim.lsp.buf.code_action,{buffer=0}) -- language specific code formatting
        -- Seems like there are a lot of these to explore or read in both vim.lsp.buff and also vim.diagnostic
        -- vim.keymap.set('n','td',vim.lsp.buf.type_definition,{buffer=0}) -- assign only for this buffer

    end
}

-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'path' },
        { name = 'ultisnips' }, -- For ultisnips users.
    }, {
        { name = 'buffer', keyword_length = 4 },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
