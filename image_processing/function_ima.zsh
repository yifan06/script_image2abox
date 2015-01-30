#
# zsh utilities function for ima file format
#

#checkDirs ${ANATOMIST_BIN}
#checkExes ${ANATOMIST_BIN}/AimsFileConvert ${T_RM}

# convertToIma input output
# convert a basic volume to an ima volume using anatomist.
convertToIma() {
    checkNbParam 2 $*

    [[ -e ${2}.ima ]] || {
	checkFiles ${1}
	echo "convert "$1" to ima file format"
	${ANATOMIST_BIN}/AimsFileConvert -i ${1} -o ${2}.ima -t U8 > /dev/null 2>&1
    }
}

# checkFiles file1 [ file2 [ ... ] ]
# verify if each file given as parameter exists
# or generate an error elsewhere
checkImaFiles() {
    for (( i = 1 ; i <= $# ; i += 1 ))
    do
	checkFiles $argv[i]".ima" $argv[i]".dim"
    done
}

# checkFiles file1 [ file2 [ ... ] ]
# verify if each file given as parameter exists
# or generate an error elsewhere
checkAnalyzeFiles() {
    for (( i = 1 ; i <= $# ; i += 1 ))
    do
	checkFiles $argv[i]".img" $argv[i]".hdr"
    done
}

# sic.
removeImaIfExist() {
    for (( i = 1 ; i <= $# ; i += 1 ))
    do
	[[ -e $argv[i].ima ]] && ${T_RM} $argv[i]
	[[ -e $argv[i].dim ]] && ${T_RM} $argv[i]
    done
}

extractStructFromLabelMap() {

    curimg=$1
    STRUCT=$2
    TMPDIR=$3
    IMGWITHEXT=`basename $curimg`
    DBPATH=`dirname $curimg`

    IMGNAME="${IMGWITHEXT%.*}"
    
    #CUR_STRUCT_FILE=${TMPDIR}/${STRUCT}/${IMGNAME}
    CUR_STRUCT_FILE=${TMPDIR}/${STRUCT}
    echo "image name: $IMGNAME"
    echo "struct name: $STRUCT"
    echo $TMPDIR

    [[ -e ${CUR_STRUCT_FILE}.ima ]] || {
        # First, I need to extract REFSTRUCT from the label map
        # Labels are those from the healthly and pathological database from /tsi/medical
	SEG_FILE=${DBPATH}/${IMGNAME}_segmentation.ima
	[[ -e ${SEG_FILE} ]] && {
	    case ${STRUCT} in
		WMl) LEVEL=2 ;;
	        GMl) LEVEL=3 ;;
                LVl) LEVEL=4 ;;
	        THl) LEVEL=10 ;;
	        CDl) LEVEL=11 ;;
	        PUl) LEVEL=12 ;;
	        V3) LEVEL=14 ;;
	        WMr) LEVEL=41 ;;
	        GMr) LEVEL=42 ;;
	        LVr) LEVEL=43 ;;
	        THr) LEVEL=49 ;;
	        CDr) LEVEL=50 ;;
	        PUr) LEVEL=51 ;;
	        tumor) LEVEL=85 ;;
	        *) echo "Unknown struct: "${STRUCT}", exit" ; exit ;;
	    esac
	    t_threshold -i ${SEG_FILE} -m 3 -l ${LEVEL} -o ${CUR_STRUCT_FILE}
	    AimsFileConvert -i ${CUR_STRUCT_FILE} -t U8 -o ${CUR_STRUCT_FILE}.ima
	    MAXIMUM=`t_minmax ${CUR_STRUCT_FILE} | grep "Maximum" | xargs | cut -d' ' -f 3`

	    [[ $MAXIMUM -eq 0 ]] && {
	        t_rm ${CUR_STRUCT_FILE}
	        echo struct" : "${CUR_STRUCT_FILE}" empty, removing it"
	        #exit 2
	    }

	    [[ -e ${CUR_STRUCT_FILE}.ima ]] && {
	        echo extraction of ${CUR_STRUCT_FILE}
	    }

	    } || {
	        echo "can't find : "${SEG_FILE}
	        echo "no segmentation for "${curimg}" : exit"
	        #exit 1
	    }
    }

}

computeDirection() {
		TAR_PATH=$1
		TAR=$2
		REF_PATH=$3
		REF=$4
		DIR=$5

		echo "$TAR_PATH is a path"
		echo "computing histogram of angles between $TAR and $REF."
		t_histoAngle3d -i1 $TAR_PATH -i2 $REF_PATH -o $DIR/${TAR}_${REF}.txt
}
