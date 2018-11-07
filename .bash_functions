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
    read -p "Delete all lines containing `tput bold`$1`tput sgr0` from `tput bold`$2`tput sgr0`? (y/n)" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        grep -vwE "$1" "$2" >| "$2".deleted 
        echo "Saved as "$2".deleted"
    fi
} 
