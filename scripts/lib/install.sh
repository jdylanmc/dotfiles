#!/usr/bin/env bash

init_install() {
  INSTALL_BACKUP_SUFFIX="${DOTFILES_BACKUP_SUFFIX:-$(date +%Y%m%d%H%M%S)}"
}

link_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"
  if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
    return
  fi
  if [[ -e "$target" || -L "$target" ]]; then
    mv "$target" "${target}.backup.${INSTALL_BACKUP_SUFFIX}"
  fi
  ln -s "$source" "$target"
}

ensure_private_file() {
  local path="$1"

  mkdir -p "$(dirname "$path")"
  if [[ ! -e "$path" ]]; then
    (
      umask 077
      : >"$path"
    )
  fi
  chmod 600 "$path"
}

is_interactive() {
  [[ -t 0 && -t 1 ]]
}

prompt_yes_no() {
  local prompt="$1"
  local default="${2:-no}"
  local answer

  if ! is_interactive; then
    return 1
  fi

  if [[ "$default" == "yes" ]]; then
    read -r -p "$prompt [Y/n] " answer || return 1
    [[ -z "$answer" || "$answer" == "y" || "$answer" == "Y" ]]
  else
    read -r -p "$prompt [y/N] " answer || return 1
    [[ "$answer" == "y" || "$answer" == "Y" ]]
  fi
}
