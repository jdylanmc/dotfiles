#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

shellcheck -x \
  "$ROOT/install.sh" \
  "$ROOT/scripts/check-public.sh" \
  "$ROOT/scripts/setup-git.sh" \
  "$ROOT/scripts/test.sh" \
  "$ROOT/scripts/lib/install.sh" \
  "$ROOT"/scripts/install/*.sh

bats "$ROOT/tests"
