#!/usr/bin/env bash

install_maestro() {
  local root="$1"
  local enabled="$2"
  local use_brew="$3"
  local maestro_repo

  if [[ "$enabled" -ne 1 ]]; then
    return
  fi

  if [[ -d "$root/../maestro/.git" ]]; then
    maestro_repo="$(cd "$root/../maestro" && pwd -P)"
  else
    maestro_repo="$HOME/.local/share/maestro"
    if [[ ! -d "$maestro_repo/.git" ]]; then
      mkdir -p "$(dirname "$maestro_repo")"
      git clone https://github.com/jdylanmc/maestro.git "$maestro_repo"
    fi
  fi

  if [[ "$use_brew" -eq 0 ]]; then
    "$maestro_repo/proto-v1/install.sh" --no-brew
  else
    "$maestro_repo/proto-v1/install.sh"
  fi
}
