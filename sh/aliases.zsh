# misc
alias l=exa
alias cd=z
alias ll="exa -la"
alias m="micro"
alias g="git"
alias n="nvim"
alias cfg="m $HOME/.zshrc"
alias src="source $HOME/.zshrc > /dev/null 2>&1"
alias p="python3"
alias py="ipython"
alias no_history="HISTFILE=/dev/null"
alias delete_history="echo > ~/.zsh_history"
alias leaderboard="git shortlog -s -n"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
alias postgres="docker exec -it postgres /bin/bash"
alias ccurl="with_jq curl"
alias delete_history="fc -R"
alias delete_session_history="history -c"
alias dm="dark-mode"
alias bat="bat --theme='Monokai Extended'"
alias vpn_login="sudo openvpn $HOME/.config/openvpn/profile.conf"
alias aws_login="sso-login.sh"

# git
alias co=checkout
alias br=branch
alias ci=commit
alias st=status
alias gc="git clone"
alias gs="git status"
alias gl="git log --graph --oneline --decorate --all"
alias gp="git pull"
alias gu="update_git_branches"
alias gck="git checkout"
alias gb="git stash && git checkout - && git stash apply"
alias gcl="git gc && git fsck && git prune"
alias gsh="git show"
alias gdb="git_delete_branches"
