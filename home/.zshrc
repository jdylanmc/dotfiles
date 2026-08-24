export LANG=en_US.UTF-8

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="eastwood"
plugins=(git brew yarn nvm docker docker-compose)

if [ -s "$ZSH/oh-my-zsh.sh" ]; then
  source "$ZSH/oh-my-zsh.sh"
fi

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
elif [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  source "/opt/homebrew/opt/nvm/nvm.sh"
elif [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
  source "/usr/local/opt/nvm/nvm.sh"
fi

if command -v nvm >/dev/null 2>&1; then
  nvm use default >/dev/null 2>&1 || true
fi

# Bind the gh CLI to the GitHub account that matches the current directory.
#
# The directory-to-account mapping is not defined here. Each untracked Git
# profile declares its own `github.account`, and Git's existing `includeIf`
# routing decides which profile applies to the current directory, so this file
# stays free of account handles and machine-specific paths:
#
#   git config --file ~/.gitconfig.personal github.account <personal-handle>
#   git config --file ~/.gitconfig.work     github.account <work-handle>
#
# GH_TOKEN is exported rather than switching the shared gh active account, so
# concurrent shells in different directories cannot fight over one global
# setting.
if command -v gh >/dev/null 2>&1; then
  typeset -gA _gh_token_cache

  _gh_account_sync() {
    local account
    account="$(git config --get github.account 2>/dev/null)"

    if [ -z "$account" ] || [ "$account" = "${_GH_ACCOUNT_PINNED-}" ]; then
      return
    fi
    if [ "$account" = "${_GH_ACCOUNT-}" ]; then
      return
    fi

    if [ -z "${_gh_token_cache[$account]-}" ]; then
      _gh_token_cache[$account]="$(GH_TOKEN= gh auth token -u "$account" 2>/dev/null)"
    fi

    if [ -n "${_gh_token_cache[$account]-}" ]; then
      export GH_TOKEN="${_gh_token_cache[$account]}"
      export _GH_ACCOUNT="$account"
    else
      print -u2 "gh: no stored credentials for '$account' (run: gh auth login)"
    fi
  }

  # Report the account in effect for the current directory.
  ghwho() {
    local pinned="${_GH_ACCOUNT_PINNED-}"
    if [ -n "$pinned" ]; then
      print "$pinned (pinned for this shell)"
    else
      print "${_GH_ACCOUNT:-none} (from $(git config --get github.account 2>/dev/null || print 'no profile'))"
    fi
  }

  # Pin an account for this shell, or pass no argument to resume directory
  # tracking.
  ghuse() {
    if [ -z "${1-}" ]; then
      unset _GH_ACCOUNT_PINNED _GH_ACCOUNT
      _gh_account_sync
      print "gh: following the current directory"
      return
    fi
    local token
    token="$(GH_TOKEN= gh auth token -u "$1" 2>/dev/null)"
    if [ -z "$token" ]; then
      print -u2 "gh: no stored credentials for '$1'"
      return 1
    fi
    export GH_TOKEN="$token"
    export _GH_ACCOUNT="$1"
    export _GH_ACCOUNT_PINNED="$1"
    print "gh: pinned to $1"
  }

  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd _gh_account_sync
  _gh_account_sync
fi

if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi
