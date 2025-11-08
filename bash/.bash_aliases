# Ubuntu デフォルトの `~/.bashrc` が `~/.bash_aliases` を参照するのでここに諸々の設定を書く

stty -ixon # disable lock by ^s

# ディレクトリの表示階層を設定
PROMPT_DIRTRIM=2

# for share history
export HISTFILE=~/.bash_history
function _share_history {
    # append
    history -a
    # clear
    history -c
    # read
    history -r
}
PROMPT_COMMAND="_share_history; $PROMPT_COMMAND"
shopt -u histappend

# Add PATH
GOPATH=~/go
PATH=/usr/local/go/bin:$GOPATH/bin:$PATH

if [ $(uname) = "Darwin" ]; then
    alias ls='ls -GF' # colorized output, display slash
else
    alias ls='ls -F --color' # colorized output, display slash
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias less='less -iMR' # ignore--case, long-prompt, row-control-chars
alias dc='docker compose'
alias d='docker'
alias relogin="exec $SHELL"
alias gtop='cd `git rev-parse --show-toplevel`'
alias clip='xsel --input --clipboard'

# git-prompt settings
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1

# Git Bash(Git for Windows)
if [[ $(uname) = *"MINGW64"* ]]; then
    PS1=''
    PS1="$PS1"'\[\033[33m\]' # change to brownish yellow
    PS1="$PS1"'\w' # current working directory
    PS1="$PS1"'\[\033[0m\]' # change color

    if type __git_ps1 > /dev/null 2>&1; then
        PS1="$PS1"'`__git_ps1`' # bash function
    fi
    PS1="$PS1"'\n$ ' # prompt: always $
else
    # base PS1
    PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'
    # PS1='[$(date '+%H:%M:%S')] '$PS1

    # Git PS1
    if [[ -e /etc/bash_completion.d/git-prompt ]]; then
        source /etc/bash_completion.d/git-prompt 
        PS1+='$(__git_ps1)'
    fi
    # exit code
    PS1+=' [$?]'
    # new line
    PS1+='\n\$ '
fi

BATCAT_OPTION=' --theme base16'
if type batcat > /dev/null 2>&1; then
    alias bat="batcat $BATCAT_OPTION"
elif type bat > /dev/null 2>&1; then
    alias bat="bat $BATCAT_OPTION"
fi

if type colordiff > /dev/null 2>&1; then
    alias diff='colordiff'
fi

# fzf integration
if type fzf > /dev/null; 2>&1; then
    export FZF_DEFAULT_OPTS='--reverse --border'

    eval "$(fzf --bash)"
fi

# change git repository with ghq and fzf
# ghq: https://github.com/x-motemen/ghq
function _fzf_cd_ghq () {
    # Git Bashの方向キーで中断される現象の対策として、リポジトリ一覧を変数に入れてからfzfを呼び出している
    # see: https://github.com/junegunn/fzf/issues/3346#issuecomment-1914765828
    local repo_list=$(ghq list -p)

    local dir=$(echo "$repo_list" | fzf)
    [ -n "${dir}" ] && cd "${dir}"
}
# call function via key binding and refresh prompt for bash
# see: https://bbs.archlinux.org/viewtopic.php?pid=820707#p820707
bind -x '"\201": _fzf_cd_ghq'
bind '"\C-g":"\201\C-m"'
bind '"\C-]":"\201\C-m"'

# git checkout by fzf
# alias gch='git branch --sort=-authordate | sed -e "s/^[ *]*//" | fzf | xargs git switch'
function gch () {
    selected_branch=$(git branch --sort=-authordate | sed -e "s/^[ *]*//" | fzf)
    if [ "$selected_branch" ]; then
        git switch $selected_branch
    fi
}

# go-task
# see: https://taskfile.dev/docs/installation
if type task > /dev/null 2>&1; then
    eval "$(task --completion bash)"
fi

# for WSL2
function rmzone() {
    sudo find ./ -type f -name '*:Zone.Identifier' -exec rm {} \;
}

# local aliases
LOCAL_ALIASES=~/.bash_aliases_local
if [ -f $LOCAL_ALIASES ]; then
    source $LOCAL_ALIASES
fi
