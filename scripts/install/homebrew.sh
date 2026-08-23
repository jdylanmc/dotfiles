#!/usr/bin/env bash

install_homebrew() {
  local root="$1"
  local enabled="$2"

  if [[ "$enabled" -ne 1 ]]; then
    return
  fi
  if ! command -v brew >/dev/null 2>&1; then
    echo "Install Homebrew from https://brew.sh, then re-run install.sh." >&2
    return 1
  fi
  brew bundle --file "$root/Brewfile"
}
