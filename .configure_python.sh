#!/bin/sh

python -m venv ~/.config/nvim/.debugpy
~/.config/nvim/.debugpy/bin/python -m pip install debugpy neovim
