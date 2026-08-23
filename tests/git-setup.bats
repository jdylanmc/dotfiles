#!/usr/bin/env bats

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd -P)"
  TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-test.XXXXXX")"
  export HOME="$TEST_ROOT/home"
  export GIT_CONFIG_NOSYSTEM=1
  export DOTFILES_BACKUP_SUFFIX=test
  mkdir -p "$HOME"
  source "$REPO_ROOT/scripts/lib/install.sh"
  source "$REPO_ROOT/scripts/install/git.sh"
  init_install
}

teardown() {
  rm -rf "$TEST_ROOT"
}

init_test_repo() {
  local path="$1"

  mkdir -p "$path"
  git -C "$path" init --quiet
}

@test "fresh install links public config and creates private files" {
  install_git "$REPO_ROOT" 0

  [ -L "$HOME/.gitconfig" ]
  [ "$(readlink "$HOME/.gitconfig")" = "$REPO_ROOT/home/.gitconfig" ]
  [ "$(stat -f '%Lp' "$HOME/.gitconfig.local")" = "600" ]
  [ "$(stat -f '%Lp' "$HOME/.gitconfig.personal")" = "600" ]
  [ "$(stat -f '%Lp' "$HOME/.gitconfig.work")" = "600" ]
}

@test "existing gitconfig is preserved instead of replaced" {
  printf '[user]\n\tname = Existing\n' >"$HOME/.gitconfig"

  run install_git "$REPO_ROOT" 0

  [ "$status" -eq 0 ]
  [ ! -L "$HOME/.gitconfig" ]
  grep -q 'Existing' "$HOME/.gitconfig"
}

@test "personal identity applies only under opensource" {
  install_git "$REPO_ROOT" 0
  write_git_identity "$HOME/.gitconfig.personal" "Personal Example" "personal@example.invalid"
  init_test_repo "$HOME/git/_opensource/project"
  init_test_repo "$HOME/git/other"

  [ "$(git -C "$HOME/git/_opensource/project" config user.email)" = "personal@example.invalid" ]
  run git -C "$HOME/git/other" config user.email
  [ "$status" -ne 0 ]
}

@test "personal identity overrides work under opensource" {
  install_git "$REPO_ROOT" 0
  write_git_identity "$HOME/.gitconfig.personal" "Personal Example" "personal@example.invalid"
  write_git_identity "$HOME/.gitconfig.work" "Work Example" "work@example.invalid"
  refresh_git_local_routing
  init_test_repo "$HOME/git/_opensource/project"
  init_test_repo "$HOME/git/other"

  [ "$(git -C "$HOME/git/_opensource/project" config user.email)" = "personal@example.invalid" ]
  [ "$(git -C "$HOME/git/other" config user.email)" = "work@example.invalid" ]
}

@test "work-only identity fails closed under opensource" {
  install_git "$REPO_ROOT" 0
  write_git_identity "$HOME/.gitconfig.work" "Work Example" "work@example.invalid"
  refresh_git_local_routing
  init_test_repo "$HOME/git/_opensource/project"
  init_test_repo "$HOME/git/other"

  run git -C "$HOME/git/_opensource/project" commit --allow-empty -m test
  [ "$status" -ne 0 ]
  run git -C "$HOME/git/other" commit --allow-empty -m test
  [ "$status" -ne 0 ]
}

@test "partial personal identity is preserved and fails closed" {
  install_git "$REPO_ROOT" 0
  git config --file "$HOME/.gitconfig.personal" user.name "Personal Example"
  git config --file "$HOME/.gitconfig.personal" --unset-all user.email || true
  write_git_identity "$HOME/.gitconfig.work" "Work Example" "work@example.invalid"
  refresh_git_local_routing
  init_test_repo "$HOME/git/_opensource/project"

  [ "$(git config --file "$HOME/.gitconfig.personal" user.name)" = "Personal Example" ]
  [ -z "$(git config --file "$HOME/.gitconfig.personal" user.email)" ]
  run git -C "$HOME/git/_opensource/project" commit --allow-empty -m test
  [ "$status" -ne 0 ]
  init_test_repo "$HOME/git/other"
  run git -C "$HOME/git/other" commit --allow-empty -m test
  [ "$status" -ne 0 ]
}

@test "missing identities fail closed for commits" {
  install_git "$REPO_ROOT" 0
  init_test_repo "$HOME/git/other"

  run git -C "$HOME/git/other" commit --allow-empty -m test

  [ "$status" -ne 0 ]
}

@test "invalid guided input does not abort setup" {
  is_interactive() {
    return 0
  }

  run setup_git_guided <<< $'y\n\n'

  [ "$status" -eq 0 ]
  [ -f "$HOME/.gitconfig.local" ]
  [ -f "$HOME/.gitconfig.personal" ]
  [ -f "$HOME/.gitconfig.work" ]
}

@test "rerun preserves identities without duplicate routing" {
  local local_mtime

  install_git "$REPO_ROOT" 0
  write_git_identity "$HOME/.gitconfig.personal" "Personal Example" "personal@example.invalid"
  write_git_identity "$HOME/.gitconfig.work" "Work Example" "work@example.invalid"
  refresh_git_local_routing
  local_mtime="$(stat -f '%m' "$HOME/.gitconfig.local")"
  sleep 1

  install_git "$REPO_ROOT" 0

  [ "$(git config --file "$HOME/.gitconfig.work" user.email)" = "work@example.invalid" ]
  [ "$(git config --file "$HOME/.gitconfig.local" --get-all include.path | wc -l | tr -d ' ')" = "1" ]
  [ "$(stat -f '%m' "$HOME/.gitconfig.local")" = "$local_mtime" ]
}
