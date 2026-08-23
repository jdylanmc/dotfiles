#!/usr/bin/env bash

git_local_config_path() {
  printf '%s\n' "$HOME/.gitconfig.local"
}

git_personal_config_path() {
  printf '%s\n' "$HOME/.gitconfig.personal"
}

git_work_config_path() {
  printf '%s\n' "$HOME/.gitconfig.work"
}

git_profile_configured() {
  local path="$1"
  local name
  local email

  name="$(git config --file "$path" --get user.name 2>/dev/null || true)"
  email="$(git config --file "$path" --get user.email 2>/dev/null || true)"
  [[ -n "$name" && -n "$email" ]]
}

write_git_identity() {
  local path="$1"
  local name="$2"
  local email="$3"

  ensure_private_file "$path"
  git config --file "$path" user.name "$name"
  git config --file "$path" user.email "$email"
  chmod 600 "$path"
}

refresh_git_local_routing() {
  local local_config
  local personal_config
  local work_config
  local current_include
  local desired_include

  local_config="$(git_local_config_path)"
  personal_config="$(git_personal_config_path)"
  work_config="$(git_work_config_path)"
  ensure_private_file "$local_config"
  ensure_private_file "$personal_config"

  desired_include=""
  if git_profile_configured "$work_config" &&
    git_profile_configured "$personal_config"; then
    desired_include="$work_config"
  elif git_profile_configured "$work_config"; then
    echo "Work Git identity is inactive until a complete personal identity exists." >&2
  fi
  current_include="$(git config --file "$local_config" --get-all include.path 2>/dev/null || true)"
  if [[ "$current_include" != "$desired_include" ]]; then
    git config --file "$local_config" --unset-all include.path >/dev/null 2>&1 || true
    if [[ -n "$desired_include" ]]; then
      git config --file "$local_config" --add include.path "$desired_include"
    fi
  fi

  chmod 600 "$local_config"
  chmod 600 "$personal_config"
}

configure_git_profile_interactive() {
  local label="$1"
  local path="$2"
  local name
  local email

  if git_profile_configured "$path"; then
    if ! prompt_yes_no "Reconfigure the existing $label Git identity?" no; then
      return
    fi
  elif ! prompt_yes_no "Configure a $label Git identity?" no; then
    return
  fi

  read -r -p "$label Git name: " name || return 1
  read -r -p "$label Git email: " email || return 1
  if [[ -z "$name" || -z "$email" ]]; then
    echo "Git name and email must both be non-empty." >&2
    return 1
  fi
  write_git_identity "$path" "$name" "$email"
}

setup_git_guided() {
  local personal_config
  local work_config

  personal_config="$(git_personal_config_path)"
  work_config="$(git_work_config_path)"
  ensure_private_file "$(git_local_config_path)"
  ensure_private_file "$personal_config"
  ensure_private_file "$work_config"

  if ! is_interactive; then
    echo "Skipping guided Git identity setup because this shell is not interactive."
    echo "Run scripts/setup-git.sh from a terminal to configure identities."
    refresh_git_local_routing
    return
  fi

  if ! configure_git_profile_interactive "personal" "$personal_config"; then
    echo "Personal Git identity was not changed." >&2
  fi
  if ! configure_git_profile_interactive "work" "$work_config"; then
    echo "Work Git identity was not changed." >&2
  fi
  refresh_git_local_routing
}

install_github_cli() {
  local root="$1"

  link_file "$root/home/.config/gh/config.yml" "$HOME/.config/gh/config.yml"
}

install_git() {
  local root="$1"
  local guided="$2"
  local source="$root/home/.gitconfig"
  local target="$HOME/.gitconfig"

  if [[ -e "$target" || -L "$target" ]]; then
    if [[ ! -L "$target" ]] || [[ "$(readlink "$target")" != "$source" ]]; then
      echo "Existing ~/.gitconfig was left unchanged." >&2
      echo "Migrate it before linking the tracked Git configuration." >&2
      return
    fi
  else
    link_file "$source" "$target"
  fi

  ensure_private_file "$(git_local_config_path)"
  ensure_private_file "$(git_personal_config_path)"
  ensure_private_file "$(git_work_config_path)"
  refresh_git_local_routing

  if [[ "$guided" -eq 1 ]]; then
    setup_git_guided
  fi
}
