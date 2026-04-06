-- Prevent sign column flickering
vim.opt.signcolumn = 'yes'

-- Global diagnostic configuration (set once, applies everywhere)
-- Could consider "INFO" as an option here
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = '●',
    severity = { min = vim.diagnostic.severity.WARN },
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

-- Reduce LSP log level to prevent large log files
vim.lsp.log.set_level('WARN')

local capabilities = require('cmp_nvim_lsp')
  .default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Global LspAttach handler
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
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function(ev)
    vim.schedule(function()
      local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = 'pyright' })
      if #clients == 0 then
        vim.lsp.enable('pyright', ev.buf)
      end
    end)

    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
  end,
})

-- Enable lua_ls for Lua files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function(ev)
    vim.schedule(function()
      local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = 'lua_ls' })
      if #clients == 0 then
        vim.lsp.enable('lua_ls', ev.buf)
      end
    end)
  end,
})
