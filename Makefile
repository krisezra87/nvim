CONFIG_PATH:=$(HOME)/.config/nvim
VENV=.debugpy

all: github arch

github:
	@[[ -d $(CONFIG_PATH) ]] || git clone git@github.com:krisezra87/nvim.git $(CONFIG_PATH)

arch:
	@echo "Setting up neovim for arch..."
	@sudo pacman -S --needed neovim flake8 python-pylint python-pylint-venv neovim
	@pip install neovim
	@python -m venv $(CONFIG_PATH)/$(VENV)
	@$(CONFIG_PATH)/$(VENV)/bin/python -m pip install debugpy neovim

ubuntu:
	@echo "Setting up neovim for ubuntu..."
	@sudo add-apt-repository ppa:neovim-ppa/unstable
	@sudo apt update
	@sudo apt install -y neovim flake8 pylint python3-venv
	@pip install neovim
	@python3 -m venv $(CONFIG_PATH)/$(VENV)
	@$(CONFIG_PATH)/$(VENV)/bin/python -m pip install debugpy neovim
