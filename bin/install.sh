#!/bin/bash
# Allow to install the .py scripts as bin programs by creating symlinks into the bin directory without the .py extension.
directory=/usr/local/bin/


joinpath() {
    local path=$1
    local component=$2

    # Remove trailing slash from path
    local trimmed_path=${path%/}

    # Add separator and component to the trimmed path
    local joined_path=$trimmed_path/$component

    echo "$joined_path"
}


if [[ -d "$directory" ]]; then 
    echo "installing tools"
    #ls *.py | while read x; do echo $x ;done
    for script in "$(pwd)/"*.py; do
        chmod +x "$script"
        base_name=$(basename $script)
        command_name="${base_name%.*}" # parameter expansion (substring removal)
        symlink_location=$(joinpath "$directory" "$command_name")

        echo "installing $script in   $symlink_location "
        ln -s "$script" $symlink_location && echo "success"|| echo "error"
    done


    
fi