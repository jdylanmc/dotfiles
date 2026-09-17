#!/usr/bin/env bash

install_terminal_code() {
  if ! command -v herdr >/dev/null 2>&1; then
    echo "Herdr is not installed. Install Brewfile dependencies, then re-run install.sh." >&2
    return 1
  fi

  if command -v tode >/dev/null 2>&1 &&
    herdr plugin list | grep -q 'zenbu-labs\.tode .* enabled'; then
    return
  fi

  herdr plugin install zenbu-labs/terminal-code/herdr-plugin --yes

  if ! command -v tode >/dev/null 2>&1; then
    echo "Terminal Code installation completed without making tode available on PATH." >&2
    return 1
  fi
}
