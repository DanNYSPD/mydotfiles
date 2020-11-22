mkcdir ()
{
    mkdir -p -- "$1" &&
    cd -P -- "$1"
    
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


