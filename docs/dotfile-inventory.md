# Development dotfile inventory

Nothing moves into this repository until it has a disposition. Potentially
credential-bearing files are classified by location and purpose without
copying or printing their contents.

| Path | Classification | Disposition |
|---|---|---|
| `~/.zshrc` | Critical, current | Sanitized baseline backported; private additions move to `~/.zshrc.local`. |
| `~/.config/wezterm/wezterm.lua` | Critical, current | Backported with optional Maestro delegation. |
| `~/.config/herdr/` | Critical, current | Owned by the Maestro repository; logs, locks, and sessions excluded. |
| `~/.local/bin/maestro`, `ai` | Critical, current | Owned by the Maestro repository. |
| `~/.gitconfig` | Critical, pending review | Do not backport until identity, includes, signing, and credential helpers are separated. |
| `~/.zshenv` | Pending review | Inspect for portable environment setup versus machine-specific paths. |
| `~/.profile`, `~/.bashrc`, `~/.tcshrc` | Possibly obsolete | Determine whether any active tool still launches these shells. |
| `~/.zshrc-e`, `~/.bashrc-e`, `~/.zshrc.pre-oh-my-zsh` | Legacy backups | Compare once, then archive or delete locally; never link as live config. |
| `~/.npmrc` | Sensitive local state | Permanently excluded; may contain registry authentication. |
| `~/.ssh/`, `~/.gnupg/` | Sensitive local state | Permanently excluded. Document setup concepts only, never key material. |
| `~/.kube/` | Sensitive local state | Permanently excluded; contains cluster endpoints and credentials. |
| cloud-service profiles and organization caches | Sensitive/work state | Permanently excluded. |
| employer tooling and authentication directories | Authentication or work runtime | Permanently excluded from dotfiles. Public agent integration belongs in Maestro only. |
| `~/.nvm/`, `~/.npm/`, `~/.yarn/` | Tool-owned runtime | Do not track. Declare installation and authored config only. |
| `~/.oh-my-zsh/` | Third-party dependency | Do not vendor. Bootstrap from its public repository. |
| `~/.cargo/`, `~/.rustup/`, `~/.dotnet/`, `~/.nuget/` | Tool-owned runtime | Do not track. Review only authored configuration files separately. |
| `~/.vscode/`, `~/.vscode-shared/` | Mixed runtime and preferences | Later review settings/keybindings/extensions only; exclude auth, caches, and workspaces. |
| `~/.gitkraken/`, `~/.gk/` | Mixed runtime and authentication | Exclude unless a clearly authored, credential-free preference file is identified. |
| `~/.zsh_history`, `~/.zsh_sessions/`, `~/.viminfo` | Runtime history | Permanently excluded. |
| generated completion dumps and `*.zwc` | Generated cache | Permanently excluded. |
| `~/.cache/`, logs, lock files, sessions | Generated runtime | Permanently excluded. |

## Review order

1. Shell startup files and legacy duplicates
2. Git configuration split into public preferences and local identity
3. Package-manager authored preferences
4. Editor settings and extension manifests
5. Language/toolchain authored configuration
6. Remaining application preferences with a documented development purpose
