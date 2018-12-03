mkc() {
    mkdir -p -- "$1" &&
      cd -P -- "$1"
}


find_files() {

while IFS= read -r f; do
    if [[ -e $2/$f ]]; then
        printf '%s Exists! \n' "$f"
    fi
done < "$1"

}


get_latest_git_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

# Usage
# $ get_latest_release "creationix/nvm"
# v0.31.4


unzip_all() {
    d=${1%.*}
    mkdir "$d"
    echo "Unzipping $1 to $d..."
    unzip -q $1 -d $d
}
    
nf() {
    STR=$( echo "#!"`which "$1"` )
    if [ ! -f "$2" ]; then
        echo "$STR" > "$2"
        echo "" >> "$2"
        if [ -z ${3+x} ]; then EDT="nano +2"; else EDT="$3 +2"; fi
            $EDT "$2"
            chmod +x "$2"
    else
        echo "File already exists!"
    fi

}

delete_line () {  
    if [ $# -ne 2 ]; then
        printf "Expected 2 arguments (Line, Filename), received $#"
        kill -INT $$
    fi
    read -p "Delete all lines containing `tput bold`$1`tput sgr0` from `tput bold`$2`tput sgr0`? (y/n)" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        grep -vwE "$1" "$2" >| "$2".deleted 
        echo "Saved as "$2".deleted"
    fi
} 

bt_fn_lock () {
    if [ "$1" == 0 ] ; then 
        echo "FnLk On" ; 
        echo "$1" | sudo tee /sys/bus/hid/devices/*17EF\:604*/fn_lock > /dev/null ;
    
    elif [ "$1" == 1 ] ; then 
        echo "FnLk Off" ; 
        echo "$1" | sudo tee /sys/bus/hid/devices/*17EF\:604*/fn_lock > /dev/null ;
    else 
        echo "invalid option" ;
    fi 
}

show_permissions () {
    PASSED="$1";
    if [[ -d $PASSED ]]; then
        local directory_given=$(readlink -f $PASSED)
        for filename in $directory_given/*; do
            stat -c "%a %n" $filename 
        done
    elif [[ -f $PASSED ]]; then
        stat -c "%a %n" $PASSED 
    else
        echo "$PASSED is not valid"
    fi
}

open_at_error () {
    while read data; do
        echo $(grep -o -P "line [0-9].{0,1}" | awk '{print $2}' | head -1) >| /tmp/error_number;
    done; 
}

relpath(){ python -c "import os.path; print os.path.relpath('$1','${2:-$PWD}')" ; }
show_latest () {
    if [ -z "$1" ]
      then
            local dir=$PWD 
    else
            local dir="$1"
    fi
        ls --sort=time --reverse "$dir" | tail -1 ;
}

add_comment () {
    if [ -z "$1" ]
    then
            echo "Usage: add_comment [comment] [filename]"
    else
        cur_com=$( getfattr -d -m - "$2" | grep user.comment )
        if [ -z "$cur_com" ]
        then
            setfattr -n user.comment -v "$1" "$2" && printf "Added comment "$1" to file "$2"\n"
        else
            printf "There is already a comment found:\n$( getfattr -d -m - "$2" )\n"
            read -p "Overwrite? [y/n] " -n 1 -r
            echo    # (optional) move to a new line
                if [[ $REPLY =~ ^[Yy]$ ]]
                then
                    setfattr -n user.comment -v "$1" "$2" && printf "Added comment "$1" to file "$2"\n"
                fi
        fi
    fi
}

view_comment () {
    if [ -z "$1" ]
    then
        echo "You must provide a file"
    else
        getfattr -d -m - "$@"
    fi
}

remove_comment () {
    if [ -z "$1" ]
    then
        echo "You must provide a file"
    else
        setfattr -x user.comment "$1"
    fi
}

list_comments () {
    shopt -s dotglob
    if [ -z "$1" ]
    then
        local d=$PWD
    else
       [[ -d "$1" ]] || local d="$1" 
    fi 
    for f in $d/*
    do
        local col1=$( ls --color=always $( relpath $f $d )  )
        local col2=$( view_comment  $( relpath $f $d ) | tail -n +2 ) 
        echo "$col1"    "${col2#*=}" | column -c 2 -t
    done
    shopt -u dotglob #This is probably unnecessary as the subshell is separate
} 
