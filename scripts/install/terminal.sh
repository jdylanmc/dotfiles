#!/usr/bin/env bash

install_terminal() {
  local root="$1"

  link_file "$root/home/.config/ghostty" "$HOME/.config/ghostty"
  link_file "$root/home/.config/cmux/cmux.json" "$HOME/.config/cmux/cmux.json"
}
