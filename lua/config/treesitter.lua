-- Load up all the parsers
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "bash", "bibtex", "json", "json5", "lua", "python", "toml", "vim" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
