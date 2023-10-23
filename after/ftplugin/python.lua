-- then setup your lsp server as usual
local lspconfig = require('lspconfig')

-- Set up lspconfig capabilities.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

lspconfig.pyright.setup{
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

    end,
    autostart = true,
    -- root_dir = vim.fs.dirname(vim.fs.find({'pyproject.toml', 'setup.py'}, { upward = true })[1]),
}
