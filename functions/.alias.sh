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
#alias cd="cd && realpath ."

#list all the containers names
alias dpsname="docker ps --format 'table {{.Names}}' | tail -n +2"
#stops all the containers
alias dpsname-stop='dpsname | while read cname ;do echo "$cname" ; docker stop "$cname" ;done'
