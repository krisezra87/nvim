-- This runs after plugins are loaded
local capabilities = require('cmp_nvim_lsp')
  .default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Global LspAttach handler (applies to ALL LSP servers)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr }

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>en', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>ep', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>up', vim.lsp.buf.code_action, opts)

    -- Symbol navigation:
    -- vim.keymap.set('n', '<leader>t', '<cmd>FzfLua lsp_workspace_symbols<cr>', opts)
    vim.keymap.set('n', '<leader>t', '<cmd>FzfLua lsp_document_symbols<cr>', opts)
  end,
})

-- Configure pyright
vim.lsp.config('pyright', {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
  capabilities = capabilities,
})

-- Configure lua_ls
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      hint = {
        enable = true,
      },
    },
  },
})

-- Enable pyright for Python files
vim.api.nvim_create_autocmd({'FileType', 'BufEnter'}, {
  pattern = '*.py',
  callback = function(ev)
    if vim.bo[ev.buf].filetype == 'python' then
      vim.schedule(function()
        vim.api.nvim_set_current_buf(ev.buf)
        vim.lsp.enable('pyright')
      end)

      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
    end
  end,
})

-- Enable lua_ls for Lua files
vim.api.nvim_create_autocmd({'FileType', 'BufEnter'}, {
  pattern = '*.lua',
  callback = function(ev)
    if vim.bo[ev.buf].filetype == 'lua' then
      vim.schedule(function()
        vim.api.nvim_set_current_buf(ev.buf)
        vim.lsp.enable('lua_ls')
      end)
    end
  end,
})
