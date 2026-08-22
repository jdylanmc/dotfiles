#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
use_brew=1
with_maestro=0

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --no-brew)
      use_brew=0
      shift
      ;;
    --with-maestro)
      with_maestro=1
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 2
      ;;
  esac
done

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "These dotfiles currently support macOS only." >&2
  exit 1
fi

if [[ "$use_brew" -eq 1 ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Install Homebrew from https://brew.sh, then re-run install.sh." >&2
    exit 1
  fi
  brew bundle --file "$ROOT/Brewfile"
fi

if [[ ! -d "$HOME/.oh-my-zsh/.git" ]]; then
  git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

backup_suffix="$(date +%Y%m%d%H%M%S)"
link_file() {
  local source="$1"
  local target="$2"
  mkdir -p "$(dirname "$target")"
  if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
    return
  fi
  if [[ -e "$target" || -L "$target" ]]; then
    mv "$target" "${target}.backup.${backup_suffix}"
  fi
  ln -s "$source" "$target"
}

link_file "$ROOT/home/.zshrc" "$HOME/.zshrc"
link_file "$ROOT/home/.config/wezterm" "$HOME/.config/wezterm"
link_file "$ROOT/home/.config/ghostty" "$HOME/.config/ghostty"
link_file "$ROOT/home/.config/cmux/cmux.json" "$HOME/.config/cmux/cmux.json"

git -C "$ROOT" config core.hooksPath .githooks

if [[ "$with_maestro" -eq 1 ]]; then
  maestro_repo=""
  if [[ -d "$ROOT/../maestro/.git" ]]; then
    maestro_repo="$(cd "$ROOT/../maestro" && pwd -P)"
  else
    maestro_repo="$HOME/.local/share/maestro"
    if [[ ! -d "$maestro_repo/.git" ]]; then
      mkdir -p "$(dirname "$maestro_repo")"
      git clone https://github.com/jdylanmc/maestro.git "$maestro_repo"
    fi
  fi
  maestro_args=()
  if [[ "$use_brew" -eq 0 ]]; then
    maestro_args+=(--no-brew)
  fi
  "$maestro_repo/proto-v1/install.sh" "${maestro_args[@]}"
fi

"$ROOT/scripts/check-public.sh"
echo "Dotfiles installed. Start a new Zsh session to load them."
