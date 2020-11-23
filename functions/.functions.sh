mkcdir ()
{
    mkdir -p -- "$@" &&
    cd -P -- "$_"
    
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
if [ ! $(uname -s) = 'Darwin'  ]; then
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
