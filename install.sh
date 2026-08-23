#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
use_brew=1
with_maestro=0
git_setup=1

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
    --no-git-setup)
      git_setup=0
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

# shellcheck source=scripts/lib/install.sh
source "$ROOT/scripts/lib/install.sh"
# shellcheck source=scripts/install/homebrew.sh
source "$ROOT/scripts/install/homebrew.sh"
# shellcheck source=scripts/install/shell.sh
source "$ROOT/scripts/install/shell.sh"
# shellcheck source=scripts/install/terminal.sh
source "$ROOT/scripts/install/terminal.sh"
# shellcheck source=scripts/install/neovim.sh
source "$ROOT/scripts/install/neovim.sh"
# shellcheck source=scripts/install/git.sh
source "$ROOT/scripts/install/git.sh"
# shellcheck source=scripts/install/maestro.sh
source "$ROOT/scripts/install/maestro.sh"

init_install
install_homebrew "$ROOT" "$use_brew"
install_shell "$ROOT"
install_terminal "$ROOT"
install_neovim "$ROOT"
install_git "$ROOT" "$git_setup"

git -C "$ROOT" config core.hooksPath .githooks
install_maestro "$ROOT" "$with_maestro" "$use_brew"

"$ROOT/scripts/check-public.sh"
echo "Dotfiles installed. Start a new Zsh session to load them."
