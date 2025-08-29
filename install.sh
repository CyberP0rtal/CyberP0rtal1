#!/usr/bin/env bash
set -e

echo "🔺 CyberP0rtal Kurulumu Başlıyor..."

# Paket yöneticisi tespiti
detect_pkg() {
  if command -v apt >/dev/null 2>&1; then echo "apt"; return; fi
  if command -v dnf >/dev/null 2>&1; then echo "dnf"; return; fi
  if command -v pacman >/dev/null 2>&1; then echo "pacman"; return; fi
  echo "unknown"
}

PKG=$(detect_pkg)
echo "[*] Paket yöneticisi: $PKG"

# Temel paketleri yükleme
install_pkgs() {
  case "$PKG" in
    apt)
      sudo apt update
      sudo apt install -y zsh git curl tmux catimg eza bat btop fzf ripgrep
      ;;
    dnf)
      sudo dnf install -y zsh git curl tmux catimg eza bat btop fzf ripgrep
      ;;
    pacman)
      sudo pacman -Syu --noconfirm
      sudo pacman -S --noconfirm zsh git curl tmux catimg eza bat btop fzf ripgrep
      ;;
    *)
      echo "Desteklenmeyen paket yöneticisi!"; exit 1;;
  esac
}
install_pkgs

# Starship kurulumu
if ! command -v starship >/dev/null 2>&1; then
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y
fi

# Klasör oluşturma
mkdir -p ~/.config/cyberportal

# Konfigürasyon kopyalama
cp config/starship.toml ~/.config/
cp config/zshrc_append.sh ~/.config/cyberportal/
cp assets/illuminati.png ~/.config/cyberportal/

# .zshrc'ye ayar ekleme
if ! grep -q "### CYBERPORTAL ###" ~/.zshrc 2>/dev/null; then
  cat ~/.config/cyberportal/zshrc_append.sh >> ~/.zshrc
fi

# Varsayılan shell'i zsh yap
if [ "$SHELL" != "$(command -v zsh)" ]; then
  chsh -s "$(command -v zsh)" || true
fi

echo "✅ Kurulum tamam! Terminali kapatıp yeniden aç."
