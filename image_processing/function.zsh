##################################################################
# functions

# output head pattern of the ontology
headOnto() {
    fileName=$1
	echo "<?xml version=\"1.0\"?>" >> $fileName
    echo "<rdf:RDF
			xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"
			xmlns:xsd=\"http://www.w3.org/2001/XMLSchema#\"
		    xmlns=\"files:///data/yiyang/dataset/Ontologies/observation#\"
			xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"
			xmlns:owl=\"http://www.w3.org/2002/07/owl#\"
		    xml:base=\"files:///data/yiyang/dataset/Ontologies/observation\">"		>> $fileName	
}	

conceptIndOnto() {
	ind=$1
	concept=$2
	fileName=$3
	echo "<owl:NamedIndividual rdf:about=\"files:///data/yiyang/dataset/Ontologies/observation#$1\">"		>> $fileName	
	echo "<rdf:type rdf:resource=\"files:///data/yiyang/dataset/Ontologies/observation#$2\"/>"		>> $fileName	
	echo "</owl:NamedIndividual>"   >> $fileName

}

roleIndOnto() {
    ind1=$1
	relation=$2
	ind2=$3
	fileName=$4
	echo "<owl:NamedIndividual rdf:about=\"files:///data/yiyang/dataset/Ontologies/observation#$1\">"		>> $fileName	
	echo "<$2 rdf:resource=\"files:///data/yiyang/dataset/Ontologies/observation#$3\"/>"		>> $fileName	
	echo "</owl:NamedIndividual>"   >> $fileName
	
}

footOnto() {
	fileName=$1
	echo "</rdf:RDF> 
		 <!-- Created with zsh script -->" >> $fileName
}

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

getFileName() {
     filePath=$1
     fileName="${filePath##*/}"
     return fileName
}
