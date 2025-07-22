#!/bin/zsh

# Usage: ./timer.sh <minutes> <command>
# Example: ./timer.sh 5 "echo 'Time is up!'"
#https://stackoverflow.com/questions/5861428/bash-script-erase-previous-line
# Get the number of minutes and the command from the arguments


if [ -n "$BASH_VERSION" ]; then
    # Source .bashrc if Bash
    source ~/.bashrc
elif [ -n "$ZSH_VERSION" ]; then
    # Source .zshrc if Zsh
    source ~/.zshrc
fi

minutes=$1
shift
command="$@"

# Convert minutes to seconds
seconds=$((minutes * 60))

# Function to display the countdown timer
function countdown {
    while [ $seconds -gt 0 ]; do
        #The "\033[0K" will delete to the end of the line - in case your progress line gets shorter at some point, although this may not be necessary for your purposes.
        # The "\r" will move the cursor to the beginning of the current line
        # The -n on echo will prevent the cursor advancing to the next line
        echo -ne "Time remaining: $seconds to execute <$command>\033[0K\r"
        sleep 1
        ((seconds--))
    done
}

# Start the countdown
countdown

# Execute the command when the timer reaches 0
eval "$command"
notify-send "command terminated!"