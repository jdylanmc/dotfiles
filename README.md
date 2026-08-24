# dotfiles

Public, source-controlled macOS development configuration.

This repository owns personal shell and terminal preferences. The reusable
coding-agent workspace is maintained separately in
[jdylanmc/maestro](https://github.com/jdylanmc/maestro). Until Maestro v2 is
implemented, `--with-maestro` installs its preserved `proto-v1` launcher.

## Fresh Mac

```sh
git clone https://github.com/jdylanmc/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --with-maestro
```

The installer:

1. installs declared public Homebrew dependencies
2. installs Oh My Zsh from its public repository if needed
3. backs up conflicting live files
4. links repository-owned Zsh startup, Git, terminal, cmux, and Neovim configuration into `$HOME`
5. guides personal and optional work Git identity setup into untracked local files
6. optionally clones and installs Maestro
7. enables versioned pre-commit and pre-push public-content checks

Use `--no-brew` to skip package installation or omit `--with-maestro` to
install only dotfiles. Use `--no-git-setup` to skip guided Git identity prompts.

## Live-file model

Files under `home/` are authoritative and linked directly into `$HOME`.
Editing a linked file edits the repository copy.

`home/.zshenv` provides portable environment setup for every Zsh invocation,
while `home/.zshrc` owns interactive shell behavior.

Private, machine-specific, or employer-specific shell additions belong in:

```text
~/.zshrc.local
```

## Git identities

`home/.gitconfig` contains identity-free shared behavior and is safe to track.
It uses Delta for paged and interactive diffs.
The installer creates private local files with mode `0600`:

| Path | Purpose |
|---|---|
| `~/.gitconfig.local` | Routes the optional default work identity. |
| `~/.gitconfig.personal` | Personal identity used under `~/git/_opensource/`. |
| `~/.gitconfig.work` | Optional default identity outside `_opensource`. |

Run `scripts/setup-git.sh` to configure or update identities. Actual names,
emails, credentials, signing identities, hosts, and employer settings are never
stored in this repository. Work identity routing remains inactive until a
complete personal identity exists, preventing it from leaking into
`_opensource`. Existing non-symlinked `~/.gitconfig` files are left untouched
until they are deliberately migrated.

`home/.config/gh/config.yml` tracks GitHub CLI preferences only. The installer
links that file individually so local `hosts.yml` authentication remains
untracked and untouched.

### GitHub account context

`home/.zshrc` binds the `gh` CLI to the GitHub account that matches the current
directory, so a machine with more than one authenticated account cannot act as
the wrong one.

The directory-to-account mapping is not defined in this repository. Each private
profile declares its own account, and the existing `includeIf` routing decides
which profile applies to the current directory:

```sh
git config --file ~/.gitconfig.personal github.account <personal-handle>
git config --file ~/.gitconfig.work     github.account <work-handle>
```

Git therefore remains the single source of truth for directory routing, and no
account handles or machine paths are tracked here.

| Command | Purpose |
|---|---|
| `ghwho` | Report the account in effect for the current directory. |
| `ghuse <handle>` | Pin an account for the current shell. |
| `ghuse` | Resume directory tracking. |

The shell exports `GH_TOKEN` rather than switching the shared `gh` active
account, so concurrent shells in different directories do not fight over one
global setting. Pair it with a `credential.https://github.com.helper` entry in
each private profile to pin Git pushes to the same account.

## Installer maintenance

`install.sh` is a thin macOS orchestrator. Shared safe-write helpers live under
`scripts/lib/`, and each installation responsibility lives in
`scripts/install/`. Run `scripts/test.sh` to execute ShellCheck and the isolated
Bats suite.

## Terminal

cmux and the terminal font are declared in the `Brewfile`.

`home/.config/ghostty/config` is read by Ghostty and by cmux, which embeds
libghostty, so one authored file applies the JetBrains Mono Nerd Font and theme
to both.

`home/.config/cmux/cmux.json` carries the authored cmux settings only: dark app
chrome and a terminal-matched sidebar, so the native window agrees with the
terminal theme, and Visual Studio Code as the preferred editor, so double-clicking
a file in the explorer opens it there rather than in cmux's preview.

One cmux-adjacent path is deliberately **not** tracked, for the reason recorded in
[`docs/dotfile-inventory.md`](./docs/dotfile-inventory.md): cmux rewrites its own
`config.ghostty` under `~/Library/Application Support/`, so linking it would fight
the application.

### cmux agent plugins

cmux surfaces coding-agent activity through per-agent plugins, which are
installed rather than linked. For the GitHub Copilot CLI:

```sh
git clone https://github.com/Attamusc/copilot-cmux
cd copilot-cmux && npm install && npm run build
copilot plugin install ./
```

It reports session, prompt, tool, and error activity to the cmux sidebar. No
Copilot configuration is copied into this repository.

That file is sourced when present and must never be copied into this
repository.

## Neovim

`home/.config/nvim` is a minimal
[LazyVim starter](https://github.com/LazyVim/starter)-style configuration.
The first Neovim launch bootstraps `lazy.nvim` and installs LazyVim's default
plugins. Add local plugin specifications under `lua/plugins/`; the generated
`lazy-lock.json` is tracked to keep plugin revisions reproducible.

The `Brewfile` declares LazyVim's command-line prerequisites and an optional
Nerd Font for icons. Run `:LazyHealth` after plugin updates to check the
installation.

## Development-dotfile audit

The ongoing classification is recorded in
[`docs/dotfile-inventory.md`](docs/dotfile-inventory.md). Files are migrated
only after they are classified and reviewed. Credential stores, histories,
caches, and tool-owned runtime state are permanently excluded.

## Security

Before every commit and push:

```sh
./scripts/check-public.sh
```

The installer configures hooks that run the same check automatically. Hooks
are defense in depth; always review staged content manually.

## Platform

macOS is supported. Windows support is intentionally left for a future
contributor.
