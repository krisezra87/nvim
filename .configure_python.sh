#!/bin/sh

python -m venv ~/.config/nvim/.debugpy
source ~/.config/nvim/debugpy/bin/python
pip install debugpy neovim
