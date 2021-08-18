-- BASH language server
-- npm i -g bash-language-server

-- Was originally this on the install site
-- require'lspconfig'.bashls.setup{}

vim.schedule(function ()
  local lsp = require "lspconfig"
  require("packer").loader("coq_nvim coq.artifacts")
  lsp.bashls.setup(require("coq")().lsp_ensure_capabilities())
end)
