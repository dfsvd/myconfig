# ==========================================
# 1. 基础环境与路径 (Environment & Paths)
# ==========================================
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/.emacs.d/bin:$PATH
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# 网络代理
export http_proxy="http://127.0.0.1:7890"
export https_proxy="http://127.0.0.1:7890"

# 智能编辑器选择 (SSH 远程时回退 vim)
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# ==========================================
# 2. 历史记录与 Zsh 行为 (History & Behavior)
# ==========================================
HISTSIZE=100000
SAVEHIST=100000
HIST_STAMPS="yyyy-mm-dd"
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

# ==========================================
# 3. Oh My Zsh 框架 (OMZ Core)
# ==========================================
export ZSH="/usr/share/oh-my-zsh"
ZSH_THEME=""

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

plugins=(git z extract)
source $ZSH/oh-my-zsh.sh

# ==========================================
# 4. 系统级插件 (System Plugins)
# ==========================================
# 彩色 Man 手册 (bat 渲染，带语法高亮)
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export LESS_TERMCAP_md="$(tput bold 2> /dev/null; tput setaf 2 2> /dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2> /dev/null)"

# Fzf
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi

# Zsh 原生插件 (系统级加载，快于 OMZ 内置)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#999999"
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/doc/pkgfile/command-not-found.zsh
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# ==========================================
# 5. 别名 (Aliases)
# ==========================================
# grep 高亮
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# 编辑器
alias nano="micro"

# 常用命令
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias la='eza -al --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.="eza -a | grep -e '^\.'"
alias cl="clear"
alias welcome='clear && fastfetch'
alias gs="git status"
alias yay="paru"
alias oc="opencode"
alias cc="claude"
alias idf='source "/home/xinian/.espressif/tools/activate_idf_v5.5.4.sh"'
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# 目录跳转
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# 精简别名
alias update="sudo pacman -Syu"
alias rmpkg="sudo pacman -Rsn"
alias cleanch="sudo pacman -Scc"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias cleanup="sudo pacman -Rsn \$(pacman -Qtdq)"
# 系统信息
alias psmem='ps -eo pid,user,%mem,rss,comm --sort=-%mem | head -20'
alias psmem10='ps -eo pid,user,%mem,rss,comm --sort=-%mem | head -11'
alias hw='hwinfo --short'
alias jctl="journalctl -p 3 -xb"
alias tb="nc termbin.com 9999"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias make="make -j\$(nproc)"
alias ninja="ninja -j\$(nproc)"

# ==========================================
# 6. 自定义函数 (Functions)
# ==========================================
# 创建并进入目录
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# 快速备份
function backup() {
  cp "$1" "$1.bak"
}

# Yazi 文件管理器
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# ==========================================
# 7. 提示符 (Prompt)
# ==========================================
eval "$(starship init zsh)"
welcome
