#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# dotfiles installer
#   - 既存ファイルはタイムスタンプ付きでバックアップ
#   - 冪等: 正しい symlink が既にあればスキップ
#   - --dry-run で実行前に確認可能
# ─────────────────────────────────────────────────────────────

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "=== DRY RUN (何も変更しません) ==="
  echo ""
fi

# ── Symlink 作成関数 ──────────────────────────────────────────

link_file() {
  local src="$1"
  local dst="$2"

  # 既に正しい symlink → スキップ
  if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
    echo "  [SKIP]    $dst"
    return
  fi

  # 既存ファイル/symlink → バックアップ
  if [[ -e "$dst" ]] || [[ -L "$dst" ]]; then
    local backup_path="$BACKUP_DIR/${dst#$HOME/}"
    if $DRY_RUN; then
      echo "  [BACKUP]  $dst → $backup_path"
    else
      mkdir -p "$(dirname "$backup_path")"
      mv "$dst" "$backup_path"
      echo "  [BACKUP]  $dst → $backup_path"
    fi
  fi

  # Symlink 作成
  if $DRY_RUN; then
    echo "  [LINK]    $dst → $src"
  else
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "  [LINK]    $dst → $src"
  fi
}

# ── ディレクトリ symlink 作成関数 ─────────────────────────────

link_dir() {
  local src="$1"
  local dst="$2"

  if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
    echo "  [SKIP]    $dst/"
    return
  fi

  if [[ -e "$dst" ]] || [[ -L "$dst" ]]; then
    local backup_path="$BACKUP_DIR/${dst#$HOME/}"
    if $DRY_RUN; then
      echo "  [BACKUP]  $dst/ → $backup_path/"
    else
      mkdir -p "$(dirname "$backup_path")"
      mv "$dst" "$backup_path"
      echo "  [BACKUP]  $dst/ → $backup_path/"
    fi
  fi

  if $DRY_RUN; then
    echo "  [LINK]    $dst/ → $src/"
  else
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "  [LINK]    $dst/ → $src/"
  fi
}

# ── Home directory dotfiles ───────────────────────────────────

echo "── Shell & Git ──"
link_file "$DOTFILES_DIR/.zshrc"      "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.zshenv"     "$HOME/.zshenv"
link_file "$DOTFILES_DIR/.zprofile"   "$HOME/.zprofile"
link_file "$DOTFILES_DIR/.gitconfig"  "$HOME/.gitconfig"

# ── .config files (単体ファイル) ──────────────────────────────

echo ""
echo "── Starship ──"
link_file "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

# ── .config directories (ディレクトリ丸ごと) ──────────────────

echo ""
echo "── Mise ──"
link_dir "$DOTFILES_DIR/.config/mise" "$HOME/.config/mise"

echo ""
echo "── Neovim ──"
link_dir "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

echo ""
echo "── Ghostty ──"
link_dir "$DOTFILES_DIR/.config/ghostty" "$HOME/.config/ghostty"

echo ""
echo "── Kitty ──"
link_dir "$DOTFILES_DIR/.config/kitty" "$HOME/.config/kitty"

echo ""
echo "── Yazi ──"
link_dir "$DOTFILES_DIR/.config/yazi" "$HOME/.config/yazi"

echo ""
echo "── Zellij ──"
link_dir "$DOTFILES_DIR/.config/zellij" "$HOME/.config/zellij"

echo ""
echo "── Fastfetch ──"
link_dir "$DOTFILES_DIR/.config/fastfetch" "$HOME/.config/fastfetch"

echo ""
echo "── Git (global ignore) ──"
link_dir "$DOTFILES_DIR/.config/git" "$HOME/.config/git"

echo ""
echo "── OpenCode ──"
link_dir "$DOTFILES_DIR/.config/opencode" "$HOME/.config/opencode"

# ── .local ファイルの雛形作成 ─────────────────────────────────

echo ""
echo "── Local overrides ──"

if [[ ! -f "$HOME/.zshrc.local" ]]; then
  if $DRY_RUN; then
    echo "  [CREATE]  ~/.zshrc.local (PC固有の設定用)"
  else
    cat > "$HOME/.zshrc.local" << 'LOCALEOF'
# ~/.zshrc.local — PC固有の設定をここに書く (git管理外)
# 例: export PATH="/opt/custom/bin:$PATH"
LOCALEOF
    echo "  [CREATE]  ~/.zshrc.local (PC固有の設定用)"
  fi
else
  echo "  [SKIP]    ~/.zshrc.local (既に存在)"
fi

if [[ ! -f "$HOME/.gitconfig.local" ]]; then
  if $DRY_RUN; then
    echo "  [CREATE]  ~/.gitconfig.local (PC固有のgit設定用)"
  else
    cat > "$HOME/.gitconfig.local" << 'LOCALEOF'
# ~/.gitconfig.local — PC固有のgit設定 (git管理外)
# 例:
# [user]
#   email = work-email@company.com
LOCALEOF
    echo "  [CREATE]  ~/.gitconfig.local (PC固有のgit設定用)"
  fi
else
  echo "  [SKIP]    ~/.gitconfig.local (既に存在)"
fi

# ── 完了 ──────────────────────────────────────────────────────

echo ""
if $DRY_RUN; then
  echo "=== DRY RUN 完了 ==="
  echo "実行するには: $0"
else
  echo "✓ dotfiles のインストールが完了しました"
  if [[ -d "$BACKUP_DIR" ]]; then
    echo "  バックアップ: $BACKUP_DIR"
  fi
  echo ""
  echo "次のステップ:"
  echo "  1. source ~/.zshrc  (シェル設定の再読み込み)"
  echo "  2. mise install     (ツールのインストール)"
fi
