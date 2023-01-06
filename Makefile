# Neovim
CONFIG_PATH:=$(HOME)/.config/nvim
VENV=.debugpy

all: neovim

neovim:
	@echo "Setting up neovim..."
	@sudo pacman -S --needed neovim flake8 python-pylint python-pylint-venv neovim
	@pip install neovim
	@python -m venv $(CONFIG_PATH)/$(VENV)
	@$(CONFIG_PATH)/$(VENV)/bin/python -m pip install debugpy neovim

test:
	@echo $(CONFIG_PATH)/$(VENV)
