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
alias makelist='mls' #long name
alias psg='ps aux | grep'

alias hhg='history | grep'
alias finame='find . -iname'

alias k9='kill -9' #quick kill process
#return 0

alias gppush='git push origin $(git branch| grep "*" | tr -d "* ")' #push current branch

alias m='make'

function mdef(){
    #show Make definition (one line after the command name is defined)
    # if a nth param is received then this function will append these nth params to the commmand definition . 
    # Is assumed that these parameters are params to the command definition so you don't have to adapt the command definition + its params
    # Given a command: make makemigrations --dry-run
    # the result will be: {content of makemigrations command} + --dry-run
    command_name=$1
    if [[ $(cat Makefile | grep "$command_name:" -c) -gt 0  ]]; then 
        echo "$command_name found"
        shift;
        echo $(cat Makefile | grep "$command_name:" -a1 |sed -n 3p | awk '{print $0}') "$@"
    fi
    #cat Makefile | grep "$1:" -a1
}
function makedefinition(){
    #full name for the function
    mdef "$@"
}
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
alias lla='ls -la'

# init python
alias pyinit='python3 -m venv env'
#Non-system  python  version(compile  versions)
alias pyinit3.7='python3.7 -m venv  env'
alias pyinit3.8='python3.8 -m venv  env'
alias pyinit3.9='python3.9 -m venv  env'
alias pyinit3.10='python3.10 -m venv  env'
alias pypip='python  -m  pip'  #pip  from  the  current  python  on  the  PATH ,  useful  for  virtual environments.
alias pyactivate='. env/bin/activate' 

alias clip='xclip -sel clip'

#exec shortcut
alias dce="docker-compose exec"
#go into the container bash-shell
alias dcebash="docker-compose exec web /bin/bash"
# run manage inside container
alias dcem="docker-compose exec web python manage.py"

alias dcem_shell="docker-compose exec web python manage.py shell"
#https://stackoverflow.com/questions/424071/how-do-i-list-all-of-the-files-in-a-commit
alias glscommit="git diff-tree --no-commit-id --name-only -r"


alias py="python "

#for env with python 2, python3 is the bin filename
alias py3="python3 "

alias phps="php -S localhost:8080"

#set flask entry point

alias fapp="export FLASK_APP="
alias fenv="export FLASK_ENV="
alias fport="export FLASK_RUN_PORT="

alias f="flask"
alias fr="flask run "

#shorthand to install with save option
alias npmi="npm install --save"

alias npmid="npm install --save-dev"


alias sc='systemctl'

alias scr='systemctl restart'
alias sce='systemctl stop'
alias scs='systemctl start'

alias c='code .'

alias django-migrate='docker-compose exec web python manage.py migrate'
alias django-makemigrations='docker-compose exec web python manage.py makemigrations'
alias django-squashmigrations='docker-compose exec web python manage.py squashmigrations'