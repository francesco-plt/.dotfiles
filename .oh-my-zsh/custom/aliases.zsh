# misc
alias l=lsd
alias ll="lsd -la"
alias nv="nvim"
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
alias godoc="godoc -http=localhost:8000"
alias ytmp3="yt-dlp -x --audio-format mp3"
alias wav2mp3="ffmpeg -vn -ar 44100 -ac 2 -b:a 320k output.mp3 -i"

# git
alias co=checkout
alias br=branch
alias ci=commit
alias st=status
alias gc="git clone"
alias gs="git status"
alias gl="git log --graph --oneline --decorate --all"
alias gp="git pull --rebase"
alias gck="git checkout"
alias gsh="git show"

# fzf
alias fzbat="fzf --preview 'bat --color=always --theme=\"Monokai Extended\" {}' --bind 'f1:execute(nvim {}),f2:execute(less -f {})'"
