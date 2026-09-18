#!/usr/bin/env bash

install_zsh_plugin() {
  local name="$1"
  local repository="$2"
  local target="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$name"

  if [[ ! -d "$target/.git" ]]; then
    git clone --depth 1 "$repository" "$target"
  fi
}

install_shell() {
  local root="$1"

  if [[ ! -d "$HOME/.oh-my-zsh/.git" ]]; then
    git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  fi

  install_zsh_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
  install_zsh_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting

  link_file "$root/home/.zshenv" "$HOME/.zshenv"
  link_file "$root/home/.zshrc" "$HOME/.zshrc"
  link_file "$root/home/.config/starship.toml" "$HOME/.config/starship.toml"
}
