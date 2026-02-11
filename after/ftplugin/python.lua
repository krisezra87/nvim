-- capabilities (same as before)
local capabilities = require('cmp_nvim_lsp')
  .default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- global LspAttach handler instead of per-server on_attach
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr }

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>en', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>ep', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>up', vim.lsp.buf.code_action, opts)
    -- vim.keymap.set('n','td',vim.lsp.buf.type_definition, opts)
  end,
})

-- define the pyright config
vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },  -- can usually be omitted; lspconfig defaults will handle it
  capabilities = capabilities,
  autostart = true,
  -- root_dir = vim.fs.dirname(vim.fs.find({'pyproject.toml', 'setup.py'}, { upward = true })[1]),
})

-- enable pyright for Python buffers
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.lsp.enable('pyright')
  end,
})

