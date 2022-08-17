
# Allow to backup a project
#
#
function backup_local(){
    local SOURCE="$1"
    local TARGET="$2"

    if [[ ! -d "$SOURCE" ]]; then 
        echo "Dir $SOURCE does not exist"
        exit 
    fi
    if [[ ! -d "$TARGET" ]]; then 
        echo "Dir $TARGET does not exist"
        exit 
    fi
    rsync -azP  --filter=":- .gitignore" $SOURCE $TARGET
}