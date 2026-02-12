#!/usr/bin/env bash
#
# Bootstrap script for a fresh machine.
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/espennilsen/dotfiles/main/scripts/install.sh | bash
#   -- or --
#   ./scripts/install.sh
#
set -euo pipefail

GITHUB_USER="espennilsen"
CHEZMOI_VERSION="latest"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[info]${NC}  $*"; }
ok()    { echo -e "${GREEN}[ok]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[warn]${NC}  $*"; }
error() { echo -e "${RED}[error]${NC} $*" >&2; }

# -------------------------------------------------------------------
# 1. Detect OS
# -------------------------------------------------------------------
OS="$(uname -s)"
info "Detected OS: $OS"

# -------------------------------------------------------------------
# 2. Install system prerequisites
# -------------------------------------------------------------------
install_prerequisites() {
  case "$OS" in
    Darwin)
      if ! command -v brew &> /dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add brew to PATH for this session
        if [[ -f /opt/homebrew/bin/brew ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      fi
      ok "Homebrew ready"

      # Install essentials that chezmoi/dotfiles depend on
      info "Installing prerequisites via brew..."
      brew install git curl
      ok "Prerequisites installed"
      ;;
    Linux)
      if command -v pacman &> /dev/null; then
        info "Installing prerequisites via pacman..."
        sudo pacman -S --needed --noconfirm git curl
      elif command -v apt-get &> /dev/null; then
        info "Installing prerequisites via apt..."
        sudo apt-get update
        sudo apt-get install --yes git curl
      else
        warn "Unknown package manager — please install git, curl, and gpg manually"
      fi
      ok "Prerequisites installed"
      ;;
    *)
      error "Unsupported OS: $OS"
      exit 1
      ;;
  esac
}

# -------------------------------------------------------------------
# 2b. Install 1Password CLI
# -------------------------------------------------------------------
install_op() {
  if command -v op &> /dev/null; then
    ok "1Password CLI already installed ($(op --version))"
    return
  fi

  info "Installing 1Password CLI..."
  case "$OS" in
    Darwin)
      brew install --cask 1password-cli
      ;;
    Linux)
      if command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm 1password-cli 2>/dev/null || {
          warn "1password-cli not found in repos (enable Chaotic AUR?)"
          warn "See: https://developer.1password.com/docs/cli/get-started/"
          return
        }
      elif command -v apt-get &> /dev/null; then
        sudo mkdir -p /etc/apt/keyrings
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor -o /etc/apt/keyrings/1password-archive-keyring.gpg
        echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main" | sudo tee /etc/apt/sources.list.d/1password.list
        sudo apt-get update
        sudo apt-get install --yes 1password-cli
      else
        warn "Could not install 1Password CLI automatically."
        warn "See: https://developer.1password.com/docs/cli/get-started/"
        return
      fi
      ;;
  esac
  ok "1Password CLI installed ($(op --version))"
  echo ""
  info "Recommended: Turn on 1Password desktop app integration."
  info "See: https://developer.1password.com/docs/cli/get-started/#step-2-turn-on-the-1password-desktop-app-integration"
  echo ""
  read -rp "Have you enabled desktop app integration? [y/N] " reply
  if [[ ! "$reply" =~ ^[Yy]$ ]]; then
    info "Setting up 1Password CLI account instead."
    read -rp "Account shorthand (e.g. personal, work): " shorthand
    if [[ -n "$shorthand" ]]; then
      op account add --shorthand "$shorthand"
      eval "$(op signin --account "$shorthand")"
    else
      warn "No shorthand provided. Skipping account setup."
      warn "Run 'op account add --shorthand <name>' manually."
    fi
  fi
}

# -------------------------------------------------------------------
# 3. Install chezmoi
# -------------------------------------------------------------------
install_chezmoi() {
  if command -v chezmoi &> /dev/null; then
    ok "chezmoi already installed ($(chezmoi --version))"
    return
  fi

  info "Installing chezmoi..."
  sh -c "$(curl -fsSL https://get.chezmoi.io)" -- -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
  ok "chezmoi installed ($(chezmoi --version))"
}

# -------------------------------------------------------------------
# 4. Set up 1Password CLI (for secret templates)
# -------------------------------------------------------------------
check_op() {
  if ! command -v op &> /dev/null; then
    warn "1Password CLI (op) is not installed."
    warn "Secret templates (SSH keys, code-server) will fail without it."
    warn "See: https://developer.1password.com/docs/cli/get-started/"
    echo ""
    read -rp "Continue without 1Password CLI? [y/N] " reply
    if [[ ! "$reply" =~ ^[Yy]$ ]]; then
      error "Aborting. Install 1Password CLI first."
      exit 1
    fi
  elif ! op account list &> /dev/null; then
    warn "Not signed in to 1Password."
    warn "See: https://developer.1password.com/docs/cli/get-started/"
    echo ""
    read -rp "Continue without signing in? (secret templates will fail) [y/N] " reply
    if [[ ! "$reply" =~ ^[Yy]$ ]]; then
      error "Aborting. Sign in to 1Password first."
      exit 1
    fi
  else
    ok "1Password CLI signed in"
  fi
}



# -------------------------------------------------------------------
# 6. Initialize and apply dotfiles
# -------------------------------------------------------------------
apply_dotfiles() {
  info "Initializing chezmoi with github.com/$GITHUB_USER/dotfiles..."

  if [[ -d "$HOME/.local/share/chezmoi" ]]; then
    warn "chezmoi source directory already exists"
    read -rp "Re-initialize? This will overwrite the source state. [y/N] " reply
    if [[ "$reply" =~ ^[Yy]$ ]]; then
      chezmoi init "$GITHUB_USER"
    fi
  else
    chezmoi init "$GITHUB_USER"
  fi

  echo ""
  info "Previewing changes (dry run)..."
  chezmoi diff || true

  echo ""
  read -rp "Apply dotfiles now? [y/N] " reply
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    chezmoi apply -v
    ok "Dotfiles applied!"
  else
    info "Skipped. Run 'chezmoi apply' when ready."
  fi
}

# -------------------------------------------------------------------
# Main
# -------------------------------------------------------------------
main() {
  echo ""
  echo "╔══════════════════════════════════════════╗"
  echo "║     Espen's Dotfiles Bootstrap           ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""

  install_prerequisites
  install_op
  install_chezmoi
  check_op
  apply_dotfiles

  echo ""
  ok "All done! Open a new terminal to pick up changes."
  info "Useful commands:"
  info "  dotfiles status   — see what would change"
  info "  dotfiles update   — pull latest and apply"
  info "  dotfiles edit     — open chezmoi source dir"
  info "  dotfiles help     — show all commands"
}

main "$@"
