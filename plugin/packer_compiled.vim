" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
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
local package_path_str = "/home/kezra/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/kezra/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/kezra/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/kezra/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/kezra/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
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
  ["indent-blankline.nvim"] = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  indentLine = {
    loaded = true,
    path = "/home/kezra/.local/share/nvim/site/pack/packer/start/indentLine"
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

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
