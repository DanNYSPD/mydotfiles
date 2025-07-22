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


#gotodjangorest "/internal/v1/tasks/     internal.views.internal_tasks.TasksInternalViewSet      internal_tasks-list" "../"
#gotodjangorest "/internal/v1/tracking/<pk>/url/ internal.views.tracking.TrackingInternalViewSet internal_tracking-url" "../"

function resolve_python_module_namespace(){
    #
    #    apps.users.model =>    apps/users/models.py
    #
    local dir_path;
    dir_path=$(echo "$1" |tr '.' '/')
    #echo "$dir_path.py"
    if [[ -f "$dir_path.py" ]]; then 
        dir_path="$dir_path.py"
        echo "exists: $dir_path"
    else 
        #TODO: resolve from parent, suppose we have "apps.users.model.MyModel" where MyModel is class defined in model file
        echo "resolving sub:$dir_path"
        #dir=${dir_path##*/}
        dir_rev=$(echo  $dir_path|rev)
        dir=${dir_rev##*/}
        
        echo "$dir"
    fi
    
}

#TODO:  create  function  to  download  a  python  version ,  extract,  go  inside  the  folder  and  the  invoke  pycompile

function pydownload(){
    tarfile_name=$(basename "$1")
    tar_extracted_dir=$(echo $tarfile_name| sed 's/.tgz//')
    echo $tarfile_name
    echo $tar_extracted_dir

    wget "$1" && tar  -xvf "$tarfile_name"

    cd "$tar_extracted_dir" && echo "you are now on: $(pwd)"
    
    echo "Download and extrated source code, now you can run pycompile function."
    

}
function  pycompile(){
    #  inspired by https://stackoverflow.com/questions/1534210/use-different-python-version-with-virtualenv/39713544#39713544
    #  Compile  the  python  of  the  current  directory  to be  installed  on  /usr/local/bin/python{dotted_version}
    #  1.  download  the  desired  version  from:https://www.python.org/downloads/source/  ->wget  https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz
    #  2.  untar                                                                            ->tar  -xvf  Python-3.7.9.tgz
    #  3.  go  inside                                                                       ->cd Python-3.7.9
    #  4.  run  this  funcion                                                               ->  pycompile
    # Note: tested from 3.7 to 3.11
    

    #sudo  dnf  install  python3-devel
    #sudo  dnf  install libffi-devel -y  :fix  _ctypes  error  on  compilation
    time ./configure                 ## 17 sec
    time make ;  echo "code $?"                    
    #generate  the  ln  for  the  compile  python version  .eg./usr/local/bin/python3.7
    time sudo make install  ;  echo "code $?"         ## 18 sec
    #erase  python compiled  files(pyc)
    time  sudo make clean     ;  echo "code $?"             ## 0.3 sec
}


function pyinstall_from_url(){
    # from a python given url with the python sourced in format tar, this funcion 1) download, 2) untar it and 3) compile
    local URL="$1"
    # download
    wget $URL
   
   
    DOWNLOADED_PYTHON_SOURCE=$(echo ${URL##*/})
    DIR_UNCOMPRESSED=$(echo ${DOWNLOADED_PYTHON_SOURCE%.*})
    echo $DIR_UNCOMPRESSED
    # untar
    tar  -xvf $DOWNLOADED_PYTHON_SOURCE
    cd $DIR_UNCOMPRESSED
    #finally compile
    pycompile
}

function pytopypath(){
    # replaces the / by . and .py from a path
    local normal_path="$1"
    local pypath=$(echo "$normal_path" | tr '/' '.' | sed 's/.py//')
    echo $pypath
    echo "from $pypath"
}