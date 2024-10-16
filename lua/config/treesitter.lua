-- Load up all the parsers
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python","bash","bibtex","regex","vim","json","json5","toml", "latex", "lua"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable={'latex', 'lua'},
  },
}
