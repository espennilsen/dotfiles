# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-02-12

### Added

- Add [mise](https://mise.jdx.dev) as polyglot version manager replacing nvm, pnpm curl installer, and brew-installed Go/Rust/Python
- Add global mise config (`~/.config/mise/config.toml`) managing node (LTS), pnpm, bun, go, python, and rust
- Add macOS lightweight shell setup without oh-my-zsh for faster startup
- Add Powerlevel10k via Homebrew on macOS (v1.20.0)
- Add fzf shell integration (Ctrl+R fuzzy history, Ctrl+T file finder)
- Add zoxide shell integration (smart `z` directory jumping)
- Add Ghostty terminal configuration (Purple Rain theme, quick terminal, keybinds)
- Add tmux configuration (Ctrl+a prefix, vi mode, TPM plugins, Ghostty clipboard)
- Add GitHub CLI (`gh`) config with `co` alias and shell completions
- Add SSH config template with 1Password IdentityAgent on macOS
- Add SSH commit signing via 1Password (`op-ssh-sign`) on macOS
- Add agent signing key for coding agents (Claude Code, pi) to sign commits without biometric prompts
- Add `git agent-commit` alias for agent-signed commits
- Add comprehensive global `.gitignore` covering macOS, editors, env/secrets, Node, Python, Rust, databases, Docker, logs, and coding agents
- Add Claude Code config (`~/.claude/settings.json`, `~/.claude/CLAUDE.md`)
- Add pi agent config (`~/.pi/agent/settings.json`)
- Add bootstrap script (`scripts/install.sh`) for fresh machine setup
- Add `dotfiles` CLI wrapper (`scripts/dotfiles`) for day-to-day management
- Add Android SDK paths to Darwin shell config (moved from `.zprofile`)
- Add macOS Homebrew casks: 1password, cursor, docker-desktop, visual-studio-code-insiders, claude, lm-studio, raycast, postman, obs, devtoys, figma, obsidian, notion, discord, telegram, whatsapp, spotify, vlc, the-unarchiver, bartender, balenaetcher, grandperspective, zerotier-one, rustdesk
- Add macOS Homebrew formulae: fzf, htop, wget, yazi, zoxide, neofetch, gum, nmap, iperf, cmake, websocat, watchman, pipx, cloudflared, gemini-cli, powershell-lts

### Changed

- Replace nvm + pnpm curl installers with mise in install script
- Replace oh-my-zsh on macOS with lightweight shell setup (compinit, inline git aliases, direct p10k sourcing)
- Replace brew-installed Go, Rust, Python with mise-managed versions
- Update Powerlevel10k from v1.15.0 to v1.20.0
- Move oh-my-zsh and Powerlevel10k external downloads to Linux-only
- Move Linux-only oh-my-zsh plugins (`mosh`, `supervisor`, `tmux`, `tmuxinator`, `ufw`) out of macOS shell config
- Restructure `.zshrc` as a chezmoi template with Darwin/Linux split
- Rename `dot_zshrc` to `dot_zshrc.tmpl` for template processing
- Rewrite README with install instructions, file inventory, and management commands

### Removed

- Remove GPG encryption from chezmoi config (all secrets use 1Password instead)
- Remove GPG keyring templates (`private_dot_gnupg/`) — incomplete without private key
- Remove `dotenv` oh-my-zsh plugin (conflicts with mise env var management)
- Remove `zsh-nvm` oh-my-zsh plugin and external download (replaced by mise)
- Remove manual bun PATH and completions from `.zshrc` (managed by mise)
- Remove `nodejs` from Ubuntu apt install list (managed by mise)

### Fixed

- Fix `.gitconfig` template syntax: single braces `{ }` → double braces `{{ }}` for chezmoi

## [0.1.0] - 2023-09-28

### Added

- Initial chezmoi dotfiles setup
- Zsh configuration with oh-my-zsh and Powerlevel10k theme
- Vim configuration
- SSH keys via 1Password (`id_ecdsa`, `id_rsa`)
- SSH authorized keys from GitHub
- GPG keyring and trustdb via 1Password
- Git configuration template with user data from chezmoi
- Powerlevel10k prompt configuration
- code-server configuration via 1Password
- i3 window manager configuration
- Sway compositor configuration
- Waybar status bar configuration and styling
- Xmodmap key remappings
- Install script with nvm, pnpm, and OS-specific packages (Arch, Ubuntu)
- Chaotic AUR setup script for Arch Linux
- Oh-my-zsh with Powerlevel10k and zsh-nvm as external dependencies
- Wallpaper

[Unreleased]: https://github.com/espennilsen/dotfiles/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/espennilsen/dotfiles/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/espennilsen/dotfiles/releases/tag/v0.1.0
