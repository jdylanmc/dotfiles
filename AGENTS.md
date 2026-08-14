# Repository instructions

This is a public personal dotfiles repository.

- Never add or push secrets, credentials, tokens, authentication state, shell history, session data, personal identifiers, employer configuration, internal endpoints, or work-specific content.
- Inventory and classify a dotfile before backporting it. A familiar filename is not evidence that its contents are safe.
- Keep private and machine-specific shell additions in `~/.zshrc.local`; it is never linked into or copied to this repository.
- Do not manage tool-owned caches, package stores, generated completions, logs, or histories.
- Run `./scripts/check-public.sh` before every commit and push.
- Prefer repository-owned source files linked into `$HOME`, with backups before replacing existing files.
- macOS is the only supported platform for now. Keep the layout open to a future Windows implementation.
