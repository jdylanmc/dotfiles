#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

# shellcheck source=scripts/lib/install.sh
source "$ROOT/scripts/lib/install.sh"
# shellcheck source=scripts/install/git.sh
source "$ROOT/scripts/install/git.sh"

init_install
setup_git_guided
