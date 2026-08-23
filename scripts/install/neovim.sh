#!/usr/bin/env bash

install_neovim() {
  local root="$1"

  link_file "$root/home/.config/nvim" "$HOME/.config/nvim"
}
