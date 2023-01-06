CONFIG_PATH:=$(HOME)/.config/nvim
VENV=.debugpy

all: github neovim

github:
	@[[ -d $(CONFIG_PATH) ]] || git clone git@github.com:krisezra87/nvim.git $(CONFIG_PATH)

neovim:
	@echo "Setting up neovim..."
	@sudo pacman -S --needed neovim flake8 python-pylint python-pylint-venv neovim
	@pip install neovim
	@python -m venv $(CONFIG_PATH)/$(VENV)
	@$(CONFIG_PATH)/$(VENV)/bin/python -m pip install debugpy neovim
