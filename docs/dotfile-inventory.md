# Development dotfile inventory

Nothing moves into this repository until it has a disposition. Potentially
credential-bearing files are classified by location and purpose without
copying or printing their contents.

| Path | Classification | Disposition |
|---|---|---|
| `~/.zshenv` | Authored, current | Backported with a portable `$HOME` path for user-local developer tools. |
| `~/.zshrc` | Critical, current | Sanitized baseline backported; private additions move to `~/.zshrc.local`. |
| `~/.config/wezterm/` | Removed | Retired after standardizing on cmux; no longer installed, linked, or tracked by this repository. |
| `~/.config/ghostty/config` | Authored, current | Backported. Read by both Ghostty and cmux, which embeds libghostty. Holds the shared font and theme settings. |
| `~/Library/Application Support/com.cmuxterm.app/config.ghostty` | Tool-owned, generated | Not tracked. `cmux themes set` rewrites this file between its own `# cmux themes start/end` markers, so linking it would fight the application. `~/.config/ghostty/config` is the authored source instead. |
| `~/.config/cmux/cmux.json` | Authored, current | Backported, trimmed to authored settings only. cmux writes ~400 lines of its own commented-out defaults into this file on first run; those are not tracked. Audited before backporting: `automation.socketPassword` is absent, and no employer or credential content is present. **Caveat:** if cmux ever rewrites this file it will write through the symlink and re-add the default dump to the repository copy, which should then be re-trimmed. |
| `~/.config/nvim/` | Absent at review | No existing configuration files were available to import. Initialized from a minimal current LazyVim starter-style baseline and linked from `home/.config/nvim`. |
| `~/.local/state/nvim/nvim.log` | Tool-owned, generated | Not imported or modified. Runtime logs remain outside the repository. |
| `~/.local/share/nvim/`, `~/.cache/nvim/` | Absent at review | No plugin data or cache required migration. Future contents remain tool-owned and untracked. |
| `~/.copilot/` | Authentication or work runtime | Permanently excluded; holds employer plugin, marketplace, and Model Context Protocol configuration. The public `copilot-cmux` plugin is declared as an install step only, never by copying this directory. |
| `~/.config/herdr/` | Critical, current | Owned by the Maestro repository; logs, locks, and sessions excluded. |
| `~/.local/bin/maestro`, `ai` | Critical, current | Owned by the Maestro repository. |
| `~/.gitconfig` | Critical, pending review | Do not backport until identity, includes, signing, and credential helpers are separated. |
| `~/.profile` | Removed | Redundant for the configured Zsh login shell after Cargo environment loading moved to the tracked `~/.zshenv`. |
| `~/.bashrc` | Removed | Contained redundant Rust setup and work-only authentication paths; Bash is not the configured login shell. |
| `~/.tcshrc` | Removed | Contained only unused Rust environment setup; tcsh is not the configured login shell. |
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
