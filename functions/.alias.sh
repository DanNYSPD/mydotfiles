#!/bin/bash

alias ddp="psql -U postgres"

alias glscommit="git diff-tree --no-commit-id --name-only -r" #followed by the commit name

alias g="git"

alias grepignorelines="grep -v ^$ | grep -v ^#"

alias ld="ls -ld" #info abount the directory

alias d="docker"
alias dc="docker-compose"
alias dexec="docker exec -it "  # get inside bash usuallu
alias dlog="docker logs " #the next parameter is tha name of the container

alias t="tmux"
alias tt="tmuxinator"
alias tmuxx="tmuxinator"

alias tls="tmux ls"
alias tkill="tmux kill-session -a"
#alias cd="cd && realpath ."

#list all the containers names
alias dpsname="docker ps --format 'table {{.Names}}' | tail -n +2"
#stops all the containers
alias dpsname-stop='dpsname | while read cname ;do echo "$cname" ; docker stop "$cname" ;done'
##quick alias
alias django-show-urls='make show_urls| grep -Ev "django.*|rest_framework" | getGotoURLDjango'

alias gspy=git status --porcelain | grep -E '*.py'  
alias gsphp=git status --porcelain | grep -E '*.php'  
alias gsjava=git status --porcelain | grep -E '*.java'  
alias gsmd=git status --porcelain | grep -E '*.md'  

alias mls='cat Makefile | grep -Eo "(.*):$" | tr -d ":"'
alias psg='ps aux | grep'

alias hhg='history | grep'
alias finame='find . -iname'

alias k9='kill -9' #quick kill process
#return 0

alias gppush='git push origin $(git branch| grep "*" | tr -d "* ")' #push current branch

alias m='make'
alias h='history'

alias ta="tmux attach"

alias postman-safe='DISABLE_WAYLAND=1 postman' #a bug in postman from snap
#$'...' (ANSI-C-like strings)	since bash 2.0. Ref:https://wiki.bash-hackers.org/scripting/bashchanges
alias k9slack=$'psg slac | grep "usr" | grep \'slack$\' | awk \'{print $2}\' | xargs kill -9' #https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings

alias v='vim'
alias s='subl'
alias j='jobs -l'

alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

##https://github.com/vikaskyadav/awesome-bash-alias
##https://javascript.plainenglish.io/5-useful-bash-aliases-to-make-you-more-productive-12c04b550479 
#https://dev.to/ablil/my-best-shell-bash-aliases-on-linux-fedora-3598
alias f='find . |grep '
alias h='history|grep '


alias ffind="find . -type f"
alias dfind="find . -type d"
