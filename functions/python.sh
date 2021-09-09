#!/bin/bash
#this function receives a line with the format of show_urls and resolves the original line
function gotodjangorest(){
    #echo "----"
    fullShowUrlOutputLine="$1"
    cwd="${2:-.}"
    #cd $cwd
    #echo "$cwd"
    current="$(pwd)"
    ##pwd
    #return 0
	routePath=$(echo "$fullShowUrlOutputLine"| awk '{print $2}')
	fullUrlNameWithDefName=$(echo "$fullShowUrlOutputLine"| awk '{print $3}')
	#defName=$(echo $fullUrlNameWithDefName |sed -r "s/\x1B\[(([0-9]+)(;[0-9]+)*)?[m,K,H,f,J]//g" | awk -vFS='-' '{print $2}')
    #https://stackoverflow.com/questions/4198138/printing-everything-except-the-first-field-with-awk
	defName=$(echo $fullUrlNameWithDefName |sed -r "s/\x1B\[(([0-9]+)(;[0-9]+)*)?[m,K,H,f,J]//g" | awk -vFS='-' '{sub($1 FS,"")}1')
    #echo "defname"
    ##echo "defname: $defName"
    defName=$(echo -n "$defName"| tr -d '\r') # | hexdump -C
    #echo "defname"
    #return 0
    #echo "$routePath"
    routePath=$(echo "$routePath" | tr '.' '/' )
    #echo "$routePath"
	#calculatedPath=$(echo "$routePath" |  sed 's/\/[a-Az-Z]*$//g'  | awk '{print $0 ".py"}')
    #https://www.unix.com/shell-programming-and-scripting/164205-awk-print-all-fields-except-last-field.html
	calculatedPath=$(echo "$routePath" |  awk -v FS='/' -v OFS='/' '{$(NF--)=""; print}' | sed 's/\/$//' |awk '{print $0 ".py"}')
    #echo "../$calculatedPath"
    calculatedPath="${current}/${cwd}${calculatedPath}"
    # cuando uso show url, las lienas no son puramente string, vienen escapadas(https://askubuntu.com/questions/831971/what-type-of-sequences-are-escape-sequences-starting-with-033)
    #https://www.unix.com/unix-for-advanced-and-expert-users/114129-remove-escape-characters-string.html
    #https://stackoverflow.com/questions/19296667/remove-ansi-color-codes-from-a-text-file-using-bash
    calculatedPath=$(echo $calculatedPath | sed -r "s/\x1B\[(([0-9]+)(;[0-9]+)*)?[m,K,H,f,J]//g")
    #calculatedPath=$(realpath "$calculatedPath")
	if [[ ! -f "$calculatedPath" ]]; then
		echo "not found <$calculatedPath>"
        cat $calculatedPath
		return 1
	fi
    #echo "encontrado: $calculatedPath"

	#echo "$calculatedPath"
    #get the function definition line(header) to get the number line in the file(as long as the header is in one line)
   # cat "$calculatedPath" | grep -n "$defName"
    #echo -n "$defName"| hexdump -C
	funtionHeader=$(cat "$calculatedPath" | grep -n "def $defName(" | grep def)

    if [[ -z "$funtionHeader" ]]; then
        #django rest replace _ by - when querying the urls so if is not found try with _
        defName=$(echo "$defName"| tr '-' '_')
        funtionHeader=$(cat "$calculatedPath" | grep -n "def $defName(" | grep def)
        if [[ -z "$funtionHeader" ]]; then
            echo -n " no header:$funtionHeader, posibly this is an automatic method from the view"
            return 1
        fi
    fi

    #echo "header: $funtionHeader"
    functionLiNumberLine=$(echo $funtionHeader| grep -Eo '[0-9]+:' | tr -d ':')
    #echo $functionLiNumberLine

    goto="${calculatedPath}:${functionLiNumberLine}"
    #eval "code -g '$goto'"
    echo -n "$goto"
}
function getGotoURLDjango(){

    while read x; do

        #echo -n "___ ";
	    echo -n "$(gotodjangorest "$x" '../')"
        echo -n " source:";
        echo $x;
        #return 0
    done
}

