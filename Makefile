CONFIG_PATH:=$(HOME)/.config/nvim
VENV=.debugpy

all: github arch

# Note: You gotta have a C compiler installed too (gcc, cc, clang, whatever).  If you want zettels, you also need fd.

github:
	@[[ -d $(CONFIG_PATH) ]] || git clone git@github.com:krisezra87/nvim.git $(CONFIG_PATH)

arch:
	@echo "Setting up neovim for arch..."
	@sudo pacman -S --needed neovim flake8 python-pylint python-pylint-venv neovim lua-language-server npm fd
	@ python3 -m pip install pyright neovim debugpy

ubuntu:
	@echo "Setting up neovim for ubuntu..."
	@sudo add-apt-repository ppa:neovim-ppa/unstable
	@sudo apt update
	@sudo apt install -y neovim flake8 pylint python3-venv fd

virtualenv:
	@pip install neovim
	@python3 -m venv $(CONFIG_PATH)/$(VENV)
	@$(CONFIG_PATH)/$(VENV)/bin/python -m pip install debugpy neovim pyright
