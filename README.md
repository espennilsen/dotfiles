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
2. Install 1Password and 1Password CLI (macOS)
3. Install chezmoi
4. Check for 1Password CLI sign-in
5. Preview changes and apply (with confirmation)

## Prerequisites

- **[1Password CLI](https://developer.1password.com/docs/cli/get-started/)** (`op`) — required on all platforms for SSH keys and code-server config
  - [1Password desktop app](https://1password.com/) is recommended but not required

## Day-to-day management

The `dotfiles` CLI is automatically symlinked to `~/.local/bin/dotfiles` on install.
It wraps chezmoi with a friendlier interface and uses [gum](https://github.com/charmbracelet/gum) for styled output when available (falls back to plain text).

### Common

| Command | Description |
|---------|-------------|
| `dotfiles status` | Show pending changes (diff) |
| `dotfiles apply [args]` | Apply dotfiles to home directory |
| `dotfiles update` | Pull from remote and apply |
| `dotfiles verify` | Dry run — preview what would change |
| `dotfiles diff [file]` | Show diff for a specific file or all |

### Editing

| Command | Description |
|---------|-------------|
| `dotfiles edit [file]` | Edit a managed file, or open the source directory in `$EDITOR` |
| `dotfiles add <file>` | Start managing a new file |
| `dotfiles forget <file>` | Stop managing a file |
| `dotfiles managed` | List all managed files |
| `dotfiles unmanaged` | List files in home not managed by chezmoi |

### Git

| Command | Description |
|---------|-------------|
| `dotfiles push [msg]` | Commit all changes and push to remote (default message: "update dotfiles") |
| `dotfiles pull` | Pull latest from remote (no apply) |
| `dotfiles git <cmd>` | Run arbitrary git commands in the source directory |
| `dotfiles cd` | Print the chezmoi source directory path |

### Diagnostics

| Command | Description |
|---------|-------------|
| `dotfiles doctor` | Check health: chezmoi, tool versions, 1Password, git remote |
| `dotfiles help` | Show all commands |

### Examples

```sh
dotfiles status                    # see what changed
dotfiles add ~/.config/foo.toml    # start managing a file
dotfiles edit ~/.zshrc             # edit the template
dotfiles verify                    # preview before applying
dotfiles push "add starship"       # commit & push
dotfiles git log --oneline -5      # recent commits
dotfiles managed | grep ssh        # find managed ssh files
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
| `~/.config/sesh/` | `private_dot_config/sesh/` | Sesh session manager config |
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
- **zsh-autosuggestions** and **zsh-syntax-highlighting** via Homebrew
- **Completions** via zsh built-in `compinit` (cached, refreshed every 24h)
- **Git aliases** defined inline
- **gh / tea** completions loaded if available
- **fzf** key bindings (Ctrl+R fuzzy history, Ctrl+T file finder)
- **zoxide** smart directory jumping (`z`)
- **sesh** smart tmux session manager (Alt+S to pick session from shell)
- **fastfetch** on shell startup
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

### tmux + sesh

[Sesh](https://github.com/joshmedeski/sesh) is a smart terminal session manager that integrates tmux, zoxide, and fzf for fast project switching.

| Keybind | Where | Action |
|---------|-------|--------|
| `Ctrl-a T` | tmux | Open sesh picker popup (fzf) |
| `Ctrl-a L` | tmux | Switch to last session (via sesh) |
| `Alt-s` | zsh | Open sesh picker inline (fzf) |

Inside the tmux picker (`Ctrl-a T`):
- `Ctrl-a` — show all sources
- `Ctrl-t` — filter tmux sessions only
- `Ctrl-g` — filter configured sessions only
- `Ctrl-x` — filter zoxide directories only
- `Ctrl-f` — find directories under `~`
- `Ctrl-d` — kill the highlighted tmux session

Config: `~/.config/sesh/sesh.toml` — add pinned sessions, startup commands, and preview settings.

**Raycast extensions** (install via Raycast Store → `⌘+Space` → "Store"):

| Extension | Description |
|---|---|
| [sesh](https://www.raycast.com/joshmedeski/sesh) | Switch tmux sessions outside the terminal (requires tmux running) |
| [GitHub](https://www.raycast.com/raycast/github) | Search PRs, issues, repos, review notifications |
| [Docker](https://www.raycast.com/priithaamer/docker) | Manage containers and images |
| [1Password](https://www.raycast.com/khasbilegt/1password) | Quick search and autofill secrets |
| [Visual Studio Code](https://www.raycast.com/thomas/visual-studio-code) | Open recent projects in VS Code / Cursor |
| [Obsidian](https://www.raycast.com/marcjulian/obsidian) | Search notes, create new ones, open vaults |
| [Spotify](https://www.raycast.com/mattisssa/spotify-player) | Play/pause, search, queue tracks |
| [Telegram](https://www.raycast.com/mommysgoodpuppy/telegram) | Search chats and send messages |
| [Claude](https://www.raycast.com/quarkself/claude) | Quick access to Claude conversations |
| [Kill Process](https://www.raycast.com/rolandleth/kill-process) | Fast process killer for stuck dev servers |
| [IP Geolocation](https://www.raycast.com/koinzhang/ip-geolocation) | Quick IP lookup |
| [Brew](https://www.raycast.com/nhojb/brew) | Search, install, update Homebrew packages |

### macOS packages (via Homebrew)

`git-lfs`, `tmux`, `jq`, `neovim`, `1password-cli`, `fd`, `gh`, `ripgrep`, `mise`, `powerlevel10k`, `sesh`, `ghostty`
