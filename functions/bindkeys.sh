

function make_expand(){
	#show the list of commands and expand the selected command and put it into the buffer so it can be edited before executing it.
	local target command
	target=$(cat Makefile | grep '.*:' | fzf) #select the command
	#echo $target
	# now I get its firts command, with sed I clean leading white spaces
	command=$(grep -m 1 -A1 "^$target" Makefile | tail -n 1|sed 's/^[[:blank:]]*//') #retrieve the command value

	BUFFER=$command #for zsh set the command into the buffer.
}



zle -N make_expand
bindkey '^n' make_expand


# pythonize() {
#     local selected_text
#     #zle copy-region-as-kill
#     #selected_text=$(xclip -o -selection clipboard)
#     #selected_text=${selected_text//\//.}
# 	if [[ -n $REGION_ACTIVE ]]; then
# 	echo $CUTBUFFER
#         #selected_text="${CUTBUFFER[$REGION_ACTIVE]}"
# 		#echo $selected_text
#         #selected_text=${selected_text//\//.}
#         #LBUFFER=${LBUFFER/$BUFFER/$selected_text}
#         #zle redisplay
#     else 
# 		echo "no selected text"
# 	fi
   
    
# }

# zle -N pythonize
# bindkey '^b' pythonize
