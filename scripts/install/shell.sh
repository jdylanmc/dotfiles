#!/usr/bin/env bash

install_shell() {
  local root="$1"

  if [[ ! -d "$HOME/.oh-my-zsh/.git" ]]; then
    git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  fi

  link_file "$root/home/.zshenv" "$HOME/.zshenv"
  link_file "$root/home/.zshrc" "$HOME/.zshrc"
}
