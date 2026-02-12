# Dotfiles

Chezmoi-managed dotfiles for macOS, Arch Linux, and Ubuntu.

## Quick Install (fresh machine)

```sh
curl -fsSL https://raw.githubusercontent.com/espennilsen/dotfiles/main/scripts/install.sh | bash
```

Or clone and run locally:

```sh
git clone git@github.com:espennilsen/dotfiles.git
cd dotfiles
./scripts/install.sh
```

The install script will:
1. Install system prerequisites (Homebrew on macOS, packages on Linux)
2. Install chezmoi
3. Check for 1Password CLI and GPG key
4. Preview changes and apply (with confirmation)

## Prerequisites

- **1Password CLI** (`op`) — needed for SSH keys and code-server config
  - Install: https://developer.1password.com/docs/cli/get-started/
  - Sign in: `eval $(op signin)`

## Day-to-day management

After install, symlink the `dotfiles` command to your PATH:

```sh
ln -sf "$(chezmoi source-path)/scripts/dotfiles" ~/.local/bin/dotfiles
```

Then use:

```sh
dotfiles status          # see what would change
dotfiles apply           # apply dotfiles
dotfiles update          # pull latest from remote and apply
dotfiles verify          # dry run — preview changes

dotfiles add ~/.config/foo.toml   # start managing a new file
dotfiles edit ~/.zshrc            # edit the chezmoi template
dotfiles forget ~/.old-file       # stop managing a file

dotfiles push "add starship"      # commit & push to remote
dotfiles pull                     # pull without applying

dotfiles doctor                   # check health of the setup
dotfiles help                     # show all commands
```

## What's included

| Target | Source | Notes |
|--------|--------|-------|
| `~/.zshrc` | `dot_zshrc.tmpl` | macOS: lightweight (no oh-my-zsh), Linux: oh-my-zsh |
| `~/.gitconfig` | `dot_gitconfig.tmpl` | User config, global gitignore, coderabbit (macOS) |
| `~/.gitignore_global` | `dot_gitignore_global` | DS_Store, node_modules, editors, .env.local |
| `~/.vimrc` | `dot_vimrc` | Vim configuration |
| `~/.p10k.zsh` | `dot_p10k.zsh.tmpl` | Powerlevel10k prompt config |
| `~/.ssh/*` | `dot_ssh/` | SSH keys (via 1Password), authorized_keys (from GitHub) |
| `~/.config/ghostty/` | `private_dot_config/ghostty/` | Ghostty terminal config |
| `~/.config/mise/` | `private_dot_config/mise/` | Global mise config (tools + settings) |
| `~/.config/i3/` | `private_dot_config/i3/` | i3 window manager (Linux) |
| `~/.config/sway/` | `private_dot_config/sway/` | Sway compositor (Linux) |
| `~/.config/waybar/` | `private_dot_config/waybar/` | Waybar status bar (Linux) |
| `~/.config/code-server/` | `private_dot_config/code-server/` | code-server (via 1Password) |

### Run-on-change scripts

- **`install-packages`** — Installs mise (with node, pnpm, bun), plus system packages per OS
- **`chaotic-aur`** — Sets up the Chaotic AUR repository (Arch only)

### External dependencies (`.chezmoiexternal.toml`)

Linux only:
- **oh-my-zsh** — from master
- **Powerlevel10k** theme — v1.20.0

## Shell setup

### macOS (no oh-my-zsh)

On macOS, the shell is kept lightweight for fast startup:
- **Powerlevel10k** sourced directly via Homebrew
- **Completions** via zsh built-in `compinit`
- **Git aliases** defined inline
- **gh / tea** completions loaded if available
- **mise** activated for tool version management

### Linux (oh-my-zsh)

On Linux, oh-my-zsh is used with these plugins:
`git`, `git-lfs`, `mosh`, `supervisor`, `tmux`, `tmuxinator`, `ufw`, `zsh-navigation-tools`

## Tool management

These dotfiles use [mise](https://mise.jdx.dev) for managing:
- **Node.js** (LTS)
- **pnpm** (latest)
- **Bun** (latest)

mise is installed automatically and activated in `.zshrc`.
Global tool versions are set in `~/.config/mise/config.toml`.
Per-project versions are configured with `mise.toml` files.

### macOS packages (via Homebrew)

`git-lfs`, `tmux`, `jq`, `neovim`, `1password-cli`, `fd`, `gh`, `ripgrep`, `mise`, `powerlevel10k`, `ghostty`
