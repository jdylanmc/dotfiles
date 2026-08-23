#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd -P)"
  TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-test.XXXXXX")"
  export HOME="$TEST_ROOT/home"
  export DOTFILES_BACKUP_SUFFIX=test
  mkdir -p "$HOME"
  source "$REPO_ROOT/scripts/lib/install.sh"
  init_install
}

teardown() {
  rm -rf "$TEST_ROOT"
}

@test "link_file backs up a conflicting file" {
  mkdir -p "$TEST_ROOT/source"
  printf 'old\n' >"$HOME/config"

  link_file "$TEST_ROOT/source" "$HOME/config"

  [ -L "$HOME/config" ]
  [ "$(readlink "$HOME/config")" = "$TEST_ROOT/source" ]
  [ "$(cat "$HOME/config.backup.test")" = "old" ]
}

@test "link_file is idempotent" {
  mkdir -p "$TEST_ROOT/source"

  link_file "$TEST_ROOT/source" "$HOME/config"
  link_file "$TEST_ROOT/source" "$HOME/config"

  [ -L "$HOME/config" ]
  [ ! -e "$HOME/config.backup.test" ]
}

@test "ensure_private_file preserves content and enforces permissions" {
  printf 'keep\n' >"$HOME/private"

  ensure_private_file "$HOME/private"
  ensure_private_file "$HOME/private"

  [ "$(cat "$HOME/private")" = "keep" ]
  [ "$(stat -f '%Lp' "$HOME/private")" = "600" ]
}
