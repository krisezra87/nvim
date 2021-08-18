-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/kezra/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/kezra/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/kezra/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/kezra/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/kezra/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  Colorizer = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/Colorizer"
  },
  ["coq.artifacts"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/coq.artifacts"
  },
  coq_nvim = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/coq_nvim"
  },
  ["elly.vim"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/elly.vim"
  },
  fzf = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["git-messenger.vim"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/git-messenger.vim"
  },
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["quick-scope"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/quick-scope"
  },
  tagbar = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/tagbar"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/targets.vim"
  },
  taskwiki = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/taskwiki"
  },
  tcomment_vim = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/tcomment_vim"
  },
  ["traces.vim"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/traces.vim"
  },
  ultisnips = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/ultisnips"
  },
  ["vim-better-whitespace"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-better-whitespace"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-indent-object"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-indent-object"
  },
  ["vim-lion"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-lion"
  },
  ["vim-matlab-fold"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-matlab-fold"
  },
  ["vim-pasta"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-pasta"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-rooter"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-rooter"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-snippets"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator"
  },
  ["vim-wordmotion"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vim-wordmotion"
  },
  vimtex = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vimtex"
  },
  vimwiki = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/vimwiki"
  }
}

time([[Defining packer_plugins]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
