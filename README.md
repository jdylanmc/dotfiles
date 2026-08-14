# dotfiles

Public, source-controlled macOS development configuration.

This repository owns personal shell and terminal preferences. The reusable
coding-agent workspace is maintained separately in
[jdylanmc/maestro](https://github.com/jdylanmc/maestro).

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
4. links repository-owned Zsh and WezTerm configuration into `$HOME`
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
