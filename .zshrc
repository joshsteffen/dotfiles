ZSH_THEME="robbyrussell"
VI_MODE_SET_CURSOR=true
MODE_INDICATOR=" "

plugins=(colored-man-pages direnv git vi-mode fzf zoxide)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

PROMPT="%(?:%{$fg_bold[green]%}%1{%} :%{$fg_bold[red]%}%1{%} )"
PROMPT+=" %{$fg[default]%}%n@%m"
PROMPT+=" %{$fg[cyan]%}%~"
PROMPT+="%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'

less_termcap[md]="${fg_bold[blue]}"

export EDITOR='nvim'
export PYTHON_BASIC_REPL=1
export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$PATH

alias cat="bat --paging=never --style=snip"
alias hx=helix
alias ls="eza --icons=auto"
alias tree="ls -T"
alias objdump="objdump -M intel -C"

function yy() { yazi --cwd-file=/tmp/yazi-cwd "$@" && cd "$(cat /tmp/yazi-cwd)" }

bindkey '^F' autosuggest-accept
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZLE_SPACE_SUFFIX_CHARS='|'
zstyle ':completion:*' rehash true
