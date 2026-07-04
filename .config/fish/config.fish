## 基础设置
## 启动时显示系统信息（fastfetch）
function fish_greeting
    fastfetch
end

# man 手册用 bat 渲染（语法高亮）
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# done 插件设置（命令完成通知）：https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

## 环境变量
# 加载 ~/.fish_profile（兼容 .profile 风格的环境变量）
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# 将 ~/.local/bin 加入 PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# 将 depot_tools 加入 PATH（Chromium 开发用）
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end


## 自定义函数
# bang-bang 插件（!! 和 !$ 快捷引用上一条命令）
# https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# 历史命令（显示时间戳）
function history
    builtin history --show-time='%F %T '
end

# 快速备份文件
function backup --argument filename
    cp $filename $filename.bak
end

# 复制目录（自动处理尾部斜杠）
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

## 常用别名
# 用 eza 替代 ls（带颜色和图标）
alias ls='eza -al --color=always --group-directories-first --icons' # 详细列表
alias la='eza -a --color=always --group-directories-first --icons'  # 所有文件（含隐藏）
alias ll='eza -l --color=always --group-directories-first --icons'  # 长格式
alias lt='eza -aT --color=always --group-directories-first --icons' # 树形结构
alias l.="eza -a | grep -e '^\.'"                                   # 只显示隐藏文件

# 日常命令
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'                                   # 硬件信息
alias big="expac -H M '%m\t%n' | sort -h | nl"              # 按大小排序已安装包
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l'          # 统计 -git 包数量
alias update='sudo pacman -Syu'

# 获取最快镜像源
alias mirror="sudo cachyos-rate-mirrors"

# 给新 Arch 用户的小彩蛋
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias tb='nc termbin.com 9999'

# 清理孤立的包
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# 查看 journalctl 错误日志
alias zj="zellij"
alias jctl="journalctl -p 3 -xb"

# 最近安装的包
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

## 提示符（starship）
starship init fish | source
