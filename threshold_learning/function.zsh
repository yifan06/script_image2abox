##################################################################
# functions

# checkFiles file1 [ file2 [ ... ] ]
# verify if each file given as parameter exists
# or generate an error elsewhere
checkFiles() {
    for (( i = 1 ; i <= $# ; i += 1 ))
    do
	[[ -f $argv[i] ]] || {
	    echo "can't find "$argv[i]", exit"
	    exit
	}
    done
}


# checkDirs dir1 [ dir2 [ ... ] ]
# verify if each directory given as parameter exists
# or generate an error elsewhere
checkDirs() {
    for (( i = 1 ; i <= $# ; i += 1 ))
    do
	[[ -d $argv[i] ]] || {
	    echo "can't find "$argv[i]", exit"
            exit
        }
    done
}

# checkDirsWarn dir1 [ dir2 [ ... ] ]
# verify if each directory given as parameter exists
# or generate an warning elsewhere
checkDirsWarn() {
    for (( i = 1 ; i <= $# ; i += 1 ))
    do
	[[ -d $argv[i] ]] || {
	    echo "warning: directory"$argv[i]" does not seem to be accessible"
        }
    done
}

# createDirs dir1 [ dir2 [ ... ] ]
# verify if each directory given as parameter exists
# or create it
createDirs() {
    for (( i = 1 ; i <= $# ; i += 1 ))
    do
	[[ -d $argv[i] ]] || {
	    echo "create directory: "$argv[i]
	    mkdir -p $argv[i]
	}
    done
}

# checkExes exe1 [ exe2 [ ... ] ]
# verify if each program given as parameter exists
# and got executable permission or generate an error elsewhere
checkExes() {
    for (( i = 1 ; i <= $# ; i += 1 ))
    do
        [[ -f $argv[i] ]] || {
                echo "Error: can't find "`basename $argv[i]`
                echo "Please fix path and relaunch"
                exit -1
        }
        [[ -x $argv[i] ]] || {
		# try to fix permission if needed
		chmod u+x $argv[i] || {
		    echo "Error: can't execute script "`basename $argv[i]`
		    echo "Please, check permission and relaunch"
		    exit -1
		    }
        }
    done
}

# checkNbParam nb_require params
# verify the number of require parameters, generate an error elsewhere
checkNbParam() {
    (( NBREQPARAM = $1 + 1 ))
    (( NBPARAM = $# - 1 ))
    PROGNAME=$2

    [[ $# -lt $NBREQPARAM ]] && {
	echo -n "error: need "$1
	echo " parameters in input instead of "$NBPARAM", exit"
	exit -1
    }

    [[ $# -gt $NBREQPARAM ]] && {
	echo -n "error: need "$1
	echo " parameters in input instead of "$NBPARAM", exit"
	exit -1
    }
}

# for each file given as a parameter, remove if exist.
removeIfExist() {
    for (( i = 1 ; i <= $# ; i += 1 ))
    do
	[[ -e $argv[i] ]] && rm $argv[i]
    done
}

minValue() {
    checkNbParam 2 $*
    [[ $1 -lt $2 ]] && { echo $1 } || { echo $2 }
}

maxValue() {
    checkNbParam 2 $*
    [[ $1 -gt $2 ]] && { echo $1 } || { echo $2 }
}

pfloat() {
    checkNbParam 1 $*
    printf "%.4f" $1
}


getExtension() {
    filePath=$1
    extension="${filePath##*.}"
    return extension
}
