#!/usr/bin/env bash

install_herdr() {
  local root="$1"

  link_file "$root/home/.config/herdr/config.toml" "$HOME/.config/herdr/config.toml"

  if ! command -v herdr >/dev/null 2>&1; then
    echo "Herdr is not installed. Install Brewfile dependencies, then re-run install.sh." >&2
    return 1
  fi

  herdr integration install copilot
}
