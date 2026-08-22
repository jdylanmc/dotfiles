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
4. links repository-owned Zsh, WezTerm, and Ghostty configuration into `$HOME`
5. optionally clones and installs Maestro
6. enables versioned pre-commit and pre-push public-content checks

Use `--no-brew` to skip package installation or omit `--with-maestro` to
install only dotfiles.

## Live-file model

Files under `home/` are authoritative and linked directly into `$HOME`.
Editing a linked file edits the repository copy.

Private, machine-specific, or employer-specific shell additions belong in:

```text
~/.zshrc.local
```

## Terminals

Both terminals are declared in the `Brewfile`.

`home/.config/ghostty/config` is read by Ghostty and by cmux, which embeds
libghostty, so one authored file themes both.

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
