#!/bin/bash
#CURRENT_DIR="$(dirname $0)"
#source "$($CURRENT_DIR/.docker.sh)"

mkcdir ()
{
    mkdir -p -- "$@" &&
    cd -P -- "$_" || return 1
    
}
function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}";  }

function anurl {
    
    urldecode $(echo "$1" | sed 's/.*=//')| xclip -sel clip
    
}
function toclass {
    tr , '\n' | sed 's/^[[:blank:]]*//' | awk '{print "public $" $1 ";"}'|xclip -sel clip
    
}

function backup(){
    # backupName="$(echo $1{,.back})"
    # backupName=$(echo $1{,.back})
    backupName=($1{,.back}) #use brace expansion to create an array
    #backupName="$(echo $1.back)"
    #echo "$backupName"
    echo "$1"
    #if [[ ! -f "$backupName"  ]]; then
    echo "${backupName[2]}"
    if [[ ! -f "${backupName[2]}"  ]]; then
        cp $backupName #i did this without quotes so it's value is take as multiple parameters
    else
        echo "another strategy"
        #another strategy is used to generate the file
        now="$(date +'%d_%m_%Y')"
        backupName="$1_${now}.back"
        if [[ ! -f "$backupName"   ]]; then
            cp $1 $backupName
        else
            now="$(date +'%d_%m_%Y_%H_%M_%S')"
            backupName="$1_${now}.back"
            if [[ ! -f "$backupName"   ]]; then
                cp $1 $backupName
            fi
        fi
    fi
    
}
function switchf(){
  #this command swith files , the first file is rename it to the second file name and viceversa, an intermediate file is created and 
  #the transaction is registered on  /tmp/switchf.log file.

  local file1=$1
  local file2=$2
  #the both filenames extensions are removed (in case the have) to create the temporal filename
  local int_file="${file1}_${file2}"
  #https://askubuntu.com/questions/881361/confirm-that-a-user-has-read-and-write-access-to-current-directory 
  #test -r 
  if [[ ! -w "$file1" ]];then 
      echo "you don't have write permission, unable to rename file 1: $file1 to file $file2"
      #exit 1  #I don't use this because it kills the terminal
      return 1
  fi
   if [[ ! -w "$file2" ]];then 
      echo "you don't have write permission, unable to rename file 2: $file2 to file: $file1"
      return 1
  fi
 echo "moving 1 to inter $int_file"
  mv $file1 $int_file
  if [[ "$?" -ne 0 ]]; then 
    echo "An error ocurred while moving $file1 to $int_file, trying to keep file"

    return 2
  fi
  mv "$file2" "$file1"
  mv "$int_file" "$file2"
  echo "switch done"

}
function targz(){
    if [[ "$#" -eq 0 ]];then 
        echo "at least one parameter is necessary"
        return 1
    fi 

    if [[ "$#" -eq 1 ]]; then 
        tar -zvcf "$1.tar.gz" "$1"
    else  
        #in this case the escenario is more complex
        result=$(find "$PWD" -name "$1")
        if [[ -n $result ]]; then 
            #echo YES
            #the name will be the name of the current directory
            local baseName=${PWD##*/} 
            #echo "$baseName"
            tar -zvcf "$baseName.tar.gz" "$@"
        else 
            #echo NO
            tar -zvcf "$1.tar.gz" "$@"
        fi
       
    fi 
}
function untargz(){
    tar -xvzf "$1"
}
function hs(){
    history | grep "$@"
}

function rsync-update(){
    if [[ ! -f "$1" ]];then
        echo "File $1 doesnt' exists"
        exit 1
    fi
     rsync -avz --update --existing "$1" "$removeServer":"$rootPath/$1" 

}

#get it from https://github.com/mathiasbynens/dotfiles/blob/main/.functions

# Normalize `open` across Linux, macOS, and Windows.
# This is needed to make the `o` function (see below) cross-platform.
if [ ! "$(uname -s)" = 'Darwin'  ]; then
    if grep -q Microsoft /proc/version; then
        # Ubuntu on Windows using the Linux subsystem
        alias open='explorer.exe';
    else
        alias open='xdg-open';
    fi
fi

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
    if [ $# -eq 0  ]; then
        open .;
    else
        open "$@";
    fi;
    
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
    
}
# Create a data URL from a file
function dataurl() {
    local mimeType=$(file -b --mime-type "$1");
    if [[ $mimeType == text/*  ]]; then
        mimeType="${mimeType};charset=utf-8";
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
    
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$@"  ]]; then
        du $arg -- "$@";
    else
        du $arg .[^.]* ./*;
    fi;
    
}

function gitls(){
#list all the branches with the date info
#REFERENCES:
#https://stackoverflow.com/questions/2514172/listing-each-branch-and-its-last-revisions-date-in-git
#https://www.commandlinefu.com/commands/view/2345/show-git-branches-by-date-useful-for-showing-active-branches
    for name in `git branch -a | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$name; done | sort -r
}


function  semantic_options(){
    type="" # feat,fix,hotfix
    PS3='Please select the type of commit: '
    optselect=("feat" 
    "fix" 
    "hotfix"
    "Quit")
    select opt in "${optselect[@]}"
    do
        case $opt in
            "feat")
               type="feat"
               break
                ;;
            "fix")
                type="fix"
                break
                ;; 
            "hotfix")
                type="hotfix"
                break
                ;;             
            "Quit")
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done

    echo  $type
}


function selectTopFeactNumberBranch(){
#based on references:

#the  logic is to select the feat branches that include a number "feat/01_XXX" "feat/{number}_", then remove the text in order to get the highest number
#given the branch "feat/{number}_" this function will return the next number,  this mecanism  assumes  that most  recent  branches  have  been  pushed  to  remote(but  if  another  colaborator  hasn't  pushed  its last branch then  a  number  colision  can  happen).
    
    type=$(semantic_options)

    git status > /dev/null
    if [[ "$?" -ne 0 ]]; then 
        echo "no repository"
        return 1
    fi
    branch_description=$(echo  "$@" |  tr '[[:blank:]]'  '_')  # remove  whitespaces  and  ensure  is  snake  case
    
	#nextBranch=$(gitls | grep -E 'feat/[0-9]{1,4}' | sed -e 's/.*origin\/feat\///' -e 's/_.*//'  | sort -r | head -n1 |tr -d '[[:blank:]]')
    #https://unix.stackexchange.com/questions/355266/how-can-i-sort-numbers-in-a-unix-shell
    #nextBranch=$(gitls | grep -E "$type/[0-9]{1,4}" | sed -e 's/.*hotfix\///' -e 's/_.*//'  | sort -V | tail -n1 |tr -d '[[:blank:]]')
	nextBranch=$(gitls | grep -E "$type/[0-9]{1,4}" |  sed -e "s/.*$type\///" -e 's/_.*//'  | sort -V | tail -n1 |tr -d '[[:blank:]]')
    echo $nextBranch
    #return  0
    #echo "$nextBranch" #for debug
    if [[ "$nextBranch" =~ [0-9]{1,4} ]]; then 
        nextBranch=$((nextBranch+1))
        newBranchName="$type/${nextBranch}_${branch_description}"
        echo "$newBranchName"
        #by uploading the new branch automatically we ensure that this branch number will no be used by another app
        gitcommand="git checkout -b $newBranchName"
        echo "git checkout -b $newBranchName && git push origin $newBranchName"
        read  "REPLY?Are you sure?" 
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            eval "${gitcommand}" #zsh
        else 
            echo "wasn't run $gitcommand"
            return 0
        fi
        return 0
    fi 
	echo 'No given branch names with the format: <feat/{number}_{featch_description}> were found! in the current repo.\nPlease make sure this repo follows that convention or if you need to create the firts branch with this convention, so the firts branch name is: \n<feat/1_{branch_description}>'
}

function git-select-top-feat-number-branch(){
    selectTopFeactNumberBranch "$@"
}

# Description: this function will list files in a tree format excluding by default git ignored files if a .gitignore is found, otherwise it will ignore common folders
# Globals: NONE
# Args:  
function tre(){

    local EXCLUDED_TREE
    #based on https://github.com/mathiasbynens/dotfiles/blob/main/.functions
    if [[ -f ".gitignore" ]]; then 
        EXCLUDED_TREE=$(cat .gitignore | grep -Ev '^$|^#' | awk -vORS='|' '{print $1} END {print ".git"}' | sed -e's/|$/\n/' -e 's/\/|/|/g')
    else 
        EXCLUDED_TREE=".git|.env|.vscode|vendor|node_modules|bower_components"
    fi
    #joins the expresion, tree doesn't seem to support "/" for dirs so we remove it, finally I add ".git" to the list in order to be avoided
    # I ignore  those files that match the wild-card pattern
    tree -aC -I "$EXCLUDED_TREE" --dirsfirst "$@" | less -FRNX;

}
# This function will go enter to the file dir of the given file to avoid "cd: not a directory" when a not dir is given
#
# Args: 1 .- File used to go to the dir
function cdf () {
    local DIR
    if [[ -f "$1" && ! -d "" ]]; then 
        DIR=$(dirname "$1")    
        cd "$DIR" || return 1 

    else 
        cd "$@" || return 1
    fi    
}

# This function will search a string until if found it, it has a "sleep 1" , 
# every time it doesn't find the docker container it will print is not found
#
# Args: 1 .- container name
function waitUntilDockerProcessIsRunning(){
	
	local PROCESS="$1"
	until docker ps | grep -m 1 "$PROCESS"; do : ; sleep 1;  echo "still not found:$PROCESS" ; done

}

# Applies a commit with a commit message format: fix|feat\(branch_name\):commit_message
#
function git-commit(){
	prefixCommitName=$(git branch| grep '*' | tr -d ' *')
	echo "git commit  -m  ' (${prefixCommitName}): $@ '" 
	type="" # feat,fix,hotfix
	PS3='Please select the type of commit: '
	optselect=("feat" 
    "fix" 
    "hotfix"
    "refactor"
    "perf"
    "Quit")
	select opt in "${optselect[@]}"
	do
	    case $opt in
	        "feat")
	           type="feat"
               break
	            ;;
	        "fix")
	            type="fix"
                break
	            ;; 
            "hotfix")
                type="hotfix"
                break
                ;;
            "refactor")
                type="refactor"
                break
                ;;
            "perf")
                type="perf"
                break
                ;;
	        "Quit")
	            break
	            ;;
	        *) echo "invalid option $REPLY";;
	    esac
	done

	local gitcommand
	gitcommand="git commit  -m  '$type(${prefixCommitName}): $@ '" 
	echo "$gitcommand" 
    
	#read -p "Are you sure to run $gitcommand? " -n 1 -r #bash way -p option has a different meaning in zsh
    read  "REPLY?Are you sure?" 

	#echo    # (optional) move to a new line
	if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        eval ${gitcommand} #zsh
    else 
	    echo "wasn't run $gitcommand"
        return 1
	fi
    
    bname=$(git branch --show-current)
    echo "git push origin $bname"
}

#context. The pipe line requires a format in the last commit message (see function git-commit in this file), when a branch is merge with another(a pull) is necesary that 
# create emtoy commit with the formated message base on the last "merge commit"
# merge message default format:Merge remote-tracking branch 'branch' into branch
function git-empty-commit-for-merge(){
    local type="fix"
    local branch_name
    local commit_format
    local back_steps
    branch_name=$(git branch --show-current)    
    commit_format="$type($branch_name)"
    back_steps=2 # TODO: allow receives this as optional param
    function get_merge_commits(){
        git log --pretty='[%h] %an: %s' -"$back_steps" | grep 'Merge.* into'
    }
    echo "prefix: $commit_format"
    merge_message=$(get_merge_commits|sed 's/.*://'| tr -d "':" )
    if [[  $(get_merge_commits | grep -v ^$ -c) -gt 0 ]]; then 
        echo "merge commit found, steps back commit number:$back_steps"
        merge_message=$(echo $merge_message| sed 's/.*://'| tr -d "'" )
        #git commit --allow-empty -m  "$commit_format: $merge_message "
        gitcommit_message="$commit_format: $merge_message "
        echo "commit message: $gitcommit_message"
        gitcommand="git commit --allow-empty -m '$gitcommit_message'"
        echo "$gitcommand"

        read  "REPLY?Are you sure to apply an empty commit with the given message?" 

        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            eval "${gitcommand}" #zsh
        else 
            echo "wasn't run: <$gitcommand>"
            return 0
        fi
        return 0
    else 
        echo "No merge commit found, back commit steps number:$back_steps"
    fi
    #echo  "$commit_format $merge_message "

}

#0 – major, 1 – minor, 2 – patch
increment_version() {
    if [[ $2 -eq 0 ]]; then 
        echo "$1" | awk -F. -v OFS=. '{print $1+1, $2 ,$3}'
    elif [[ $2 -eq 1 ]]; then 
        echo "$1" | awk -F. -v OFS=. '{print $1, $2+1 ,$3}'
    elif [[ $2 -eq 2 ]]; then 
        echo "$1" | awk -F. -v OFS=. '{print $1, $2 ,$3+1}'
    fi
    
}

function tagIncrement(){
    lastTag=$(git tag | sort -r | head -n1)
    echo "last commit: $lastTag"
    echo -n "minor: "
    increment_version $lastTag 1
    echo -n "patch: "
    increment_version $lastTag 2 
     
    echo "git tag -a $(increment_version $lastTag 1) -m 'messageHere' or git tag -a $(increment_version $lastTag 2) -m 'messageHere' " 
    echo "git push --tags"
}
# if we have a list of files and I just want to list those with a numbger bigger than the specified 
# 01_XXX
# 03_XX
# 0004_xxxx
# 05_xxx
# 06_xxx
# >ls_files_that_start_with_number_since_value 04 
# output:
# 05_xxx
# 05_xxx
function ls_files_that_start_with_number_gt_than(){
    local OFFSET
    OFFSET="$1"
    local EXTENSION="${2:-py}"
    #>&2 echo $EXTENSION
    for file in *."$EXTENSION";
    do
        number=$(echo "$file" | cut -f1 -d'_'); #give files with the structure "0015_auto_xxxx.py" the separator is '_' , I focus only  in the firts part which is the number XXXX 
        #echo $number #for debug
        [[ $number -gt $OFFSET ]] && echo "$file"
    done
}

function pg_normalize_fk_constraints(){
    sed 's/FK/fk_/' | sed -E '/ALTER/s/([0-9]{1,6})( FOR.*CES )(.* )/_\3\2\3/g' 
}

function git-last-commit-message(){
# get the las commit message from a non-merge commit.
# ref:https://stackoverflow.com/questions/22247035/how-to-find-latest-non-merge-commit-message-in-git
	git show $(git rev-list --no-merges -n 1 HEAD) -s --format=%s
}
# compare local branch with remote (default origin)
# usage:
# git-diff-with-remote 
# git-diff-with-remote --name-only
function git-diff-remote(){
    branch_name=$(git branch --show-current)
    remote='origin' #TODO: Receives as argument(useful when has multiple remote)
    git diff "$@" "$branch_name" "$remote/$branch_name"
}

function pass(){
    openssl rand -base64 10
}

function django-start-app-old(){
    #https://stackoverflow.com/questions/38093854/django-how-to-startapp-inside-an-apps-folder
    # inits an app inside apps directory
    local app_dir="apps/$1"
    echo "creating app_dir:$app_dir"
    mkdir -p "$app_dir"
    python manage.py startapp "$1" "$app_dir"
}
function django-start-app(){
    #https://stackoverflow.com/questions/38093854/django-how-to-startapp-inside-an-apps-folder
    # inits an app iniside apps dir and create aditional folders and files according to a given convention
    # Ensure to have pyactivate environment
    local STANDART_APPS_DIR="apps"
    if [[ ! -d "$STANDART_APPS_DIR" ]];then 
        echo "No apps dir found" && return 1
    fi

    cd "$STANDART_APPS_DIR"    
    if [[ -d "$1" ]]; then 
        echo "app $1 already exists in apps module"
    else
        echo "starting app (initializin).. $1" 
        MANAGE="../manage.py"
        if [[ ! -f  "$MANAGE" ]]; then
            echo "Not found: $MANAGE"
            return 1
        fi
        python "$MANAGE" startapp "$1" 
        if [[ "$?" -ne 0 ]]; then 
              echo "Error on command, returning to original dir. Please check you are 1) in the environment files." && cd - && return 1
        fi  
        rm "$1/tests.py"
    fi
    #TODO: modify apps.py to set the name with the "apps.XXX" and add the label

    #create aditional files
  
    echo "Creating additional files:"
    mkdir -p "$1/tests"
    touch "$1/tests/__init__.py" # declare test as module
    additional_files=("definitions.py" "factories.py" "serializers.py" "urls.py" "services.py" "__init__.py" "celery_tasks.py")
    
    for str in "${additional_files[@]}"; do
        touch "$1/$str" # declare test as module
    done

    cd "-" #we return to previous path
}

function django-add-command(){
    #https://stackoverflow.com/questions/38093854/django-how-to-startapp-inside-an-apps-folder
    #https://docs.djangoproject.com/en/4.0/howto/custom-management-commands/
    # inits an command module inisde django app given in the first param
    local STANDART_APPS_DIR="apps"
    if [[ ! -d "$STANDART_APPS_DIR" ]];then 
        echo "No apps dir found" && return 
    fi

    cd "$STANDART_APPS_DIR"    
    if [[ -z "$1" ]]; then 
        echo "app param 1 $1 emtpy"    
        return 
    fi
    if [[ ! -d "$1" ]]; then 
        echo "app $1 not exists in apps module of the system"    
        return 
    fi
    #create aditional files
  
    echo "Creating additional command files:"
    mkdir -p "$1/management/commands"
    touch "$1/management/__init__.py" # declare test as module
    touch "$1/management/commands/__init__.py" # declare test as module
    additional_files=("command.py")
    
    for str in "${additional_files[@]}"; do
        touch "$1/management/commands/$str" # declare test as module
    done

    cd "-" #we return to previous path
}


function git-amend(){
    branch_name=$(git branch --show-current)
    PS3='Please select the type of commit: '
    type=''
	optselect=("feat" 
    "fix" 
    "hotfix" 
    "Quit")
	select opt in "${optselect[@]}"
	do
	    case $opt in
	        "feat")
	           type="feat"
               break
	            ;;
	        "fix")
	            type="fix"
                break
	            ;;
            "hotfix")
                type="hotfix"
                break
                ;;              
	        "Quit")
	            break
	            ;;
	        *) echo "invalid option $REPLY";;
	    esac
	done
    gitcommand="git commit --amend -m '$type($branch_name): $@'"
    echo "$gitcommand" 
    
	#read -p "Are you sure to run $gitcommand? " -n 1 -r #bash way -p option has a different meaning in zsh
    read  "REPLY?Are you sure?" 

	#echo    # (optional) move to a new line
	if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        eval ${gitcommand} #zsh
    else 
	    echo "wasn't run $gitcommand"
        return 1
	fi
}

function ttstart (){
    #https://unix.stackexchange.com/questions/19014/how-to-strip-multiple-spaces-to-one-using-sed
    project_name=$(tt ls| tail -n+2| sed 's/  */ /g' | tr ' ' '\n'|fzf)
    
    if [[ -n $project_name ]]; then 
        tmuxinator start "$project_name" && echo "$project_name started!!"
    else
        echo "No project selected!"
    fi
}



function ttc(){
    session_name=$(tmux list-sessions | awk -F: '{print $1}'|fzf)
    if [[ -n "$session_name" ]]; then 
        tmux attach -t "$session_name"
    else
        echo "You need to select a tmux session"
    fi
}
function mlss(){
    if [[  -f "Makefile" ]]; then  
        command=$(cat Makefile | grep -Eo "(.*):$" | tr -d ":" |fzf)

        if [[ -n "$command" ]]; then 
            make "$command"
        else 
            echo "No command in makefile selected"
        fi

    else 
        echo 'No make file exist'
   
    fi
}

function load_enviroments_variables_from_file(){
    #loads .env files with export format.
    source <(cat local/.env | sed 's/=\(.*\)/="\1"/'| grep '=' | grep -v ^# | awk '{print "export "$0}')
}

function unset_environment_variables_from_file(){
    source <(cat local/.env | grep '='| sed 's/=.*//g'| grep -v '^# '| awk '{print "unset "$0}')
}

function git_ensure_staged_files(){
    files=$(git diff --name-only --cached | grep -v ^$)
    match_words=(breakpoint TODO)

    for file in "${files[@]}"; do
        for word in "${match_words[@]}"; do
            grep -ni "$word" "$file";
            # if grep -n "$word" "$file"; then
            #     echo "$file"
            #     break
            # fi
        done
    done
}