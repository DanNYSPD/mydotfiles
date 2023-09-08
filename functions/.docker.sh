#!/bin/bash

function dcbash(){
    # This function list the docker containers and then get into its bash terminal
    #

    instance=$(docker ps | awk '{print $2 ":" $1}' | tail -n+2|fzf)

    if [[ -n "$instance" ]]; then 
        echo $instance
        #with NF we always get the last column of the f separator, in many cases a tag is used making 3th columns
        container_id=$(echo "$instance"| awk -F: '{print $NF}')
        docker exec -it "$container_id" /bin/bash || docker exec -it "$container_id" /bin/bash
    else
        echo "You need to select a container"
    fi
}

function dcstop(){
    #This function list the docker containers and then get stop it
    
    instance=$(docker ps | awk '{print $2 ":" $1}' | tail -n+2|fzf --header='Select the container to stop.CTRL-c or ESC to quit')

    if [[ -n "$instance" ]]; then 
        echo "Stopping: $instance"
        #with NF we always get the last column of the f separator, in many cases a tag is used making 3th columns
        container_id=$(echo "$instance"| awk -F: '{print $NF}')
        docker stop "$container_id" && echo "Stopped!"
    else
        echo "You need to select a container"
    fi
}