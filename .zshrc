eval "$(/opt/homebrew/bin/mise activate zsh)"

export EDITOR="nvim"
export VISUAL="nvim"
source <(fzf --zsh)
eval "$(zoxide init zsh)"

export PATH="/Users/yy/.antigravity/antigravity/bin:$PATH"
export PATH="$PATH:/Users/yy/.lmstudio/bin"
export PATH="$HOME/.local/bin:$PATH"

alias pnpx='pnpm dlx'
alias cat='bat --paging=never'
alias ls='eza --icons --group-directories-first'
alias ll='eza --icons --group-directories-first -la --git'
alias la='eza --icons --group-directories-first -a'
alias lt='eza --icons --group-directories-first --tree --level=3'
alias lg='lazygit'
alias vim='nvim'
alias vi='nvim'
alias oc='opencode'
alias cc='claude'
alias g='git'
alias gst='git status'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate -20'

# ── Workspace shortcuts ──────────────────────────────────────
alias ws='cd ~/ws'
alias wsg='cd ~/ws/github.com'

# pp: project picker — fzf で ~/ws/github.com 配下のプロジェクトへ移動
function pp() {
  local base=~/ws/github.com
  local dir
  dir=$(find "$base" -mindepth 2 -maxdepth 2 -type d 2>/dev/null \
    | sed "s|$base/||" \
    | sort \
    | fzf --height=40% --reverse --prompt="project> " --preview "eza --icons --group-directories-first $base/{}")
  [ -n "$dir" ] && cd "$base/$dir"
}

# mkp: プロジェクト作成 — ~/ws/github.com/<owner>/<repo> を作って移動
function mkp() {
  if [ -z "$1" ]; then
    echo "Usage: mkp <owner/repo>"
    return 1
  fi
  local target=~/ws/github.com/$1
  mkdir -p "$target" && cd "$target"
}

stty discard undef
function yazi-cd() {
  local tmp="$(mktemp -t yazi_cd.XXXXXX)"
  command yazi --cwd-file="$tmp" "$@"
  if [ -f "$tmp" ]; then
    local dir="$(command cat "$tmp")"
    rm -f "$tmp"
    [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
  fi
}
bindkey -s '^O' 'yazi-cd\n'

if [[ -o interactive ]] && [[ -z "$FASTFETCH_SHOWN" ]]; then
  export FASTFETCH_SHOWN=1
  fastfetch
fi

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(starship init zsh)"

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
