#!/bin/bash
#install rip
version=0.11.3 && [[ ! -f "rip" ]] &&wget "https://github.com/nivekuil/rip/releases/download/0.12.0/rip" && chmod +x "rip" && sudo cp "rip" /usr/local/bin/rip || echo "already exists rip file"
