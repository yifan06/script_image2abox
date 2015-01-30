#!/bin/zsh

# for each path contains in $INPUTFILE,
# compute different cost
REFSTRUCT=$1
RELATION=$2
TARGET=$3

# parameters :
LOCALREP=`pwd`
# image directory
# IMGDB_HEALTHY=/tsi/medical/Brain/Normal/db-sains
# IMGDB_PATHOS=/tsi/medical/Brain/pathology/db-pathos

IMGDB_HEALTHY=/data/yiyang/dataset/image/Brain/db-sains
IMGDB_PATHOS=/data/yiyang/dataset/image/Brain/db-pathos

#IMGDB_HEALTHY=~/dataset/image/Brain/Normal/db-sains
#IMGDB_PATHOS=~/dataset/image/Brain/Pathology/db-pathos

#
# output directory
OUTPUT=/data/yiyang/sr_threshold_histo/results
TMPDIR=${OUTPUT}/fuzzySubset
# load environment and functions
source function.zsh
source function_ima.zsh
source spatialRelation.zsh

##################################################################
# local requirement

# check for directory and executable
checkDirs $IMGDB_HEALTHY $IMGDB_PATHOS
############################################################################
# Begin

extractStructFromLabelMap() {

    curimg=$1
    STRUCT=$2
    TMPDIR=$3
    IMGNAME=`basename $curimg`
    DBPATH=`dirname $curimg`

    CUR_STRUCT_FILE=${TMPDIR}/${STRUCT}/${IMGNAME}

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
	        WMl) LEVEL=41 ;;
	        GMl) LEVEL=42 ;;
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
		exit 2
	    }

	    [[ -e ${CUR_STRUCT_FILE}.ima ]] && {
		echo extraction of ${CUR_STRUCT_FILE}
	    }

	    } || {
		echo "can't find : "${SEG_FILE}
		echo "no segmentation for "${curimg}" : exit"
		exit 1
	    }
    }

}


# create output directory if not exist
[[ -d ${OUTPUT} ]] || mkdir ${OUTPUT}
# create tmpdir
[[ -d ${TMPDIR} ]] || mkdir ${TMPDIR}
[[ -d ${TMPDIR}/${REFSTRUCT} ]] || mkdir ${TMPDIR}/${REFSTRUCT}
[[ -d ${TMPDIR}/${TARGET} ]] || mkdir ${TMPDIR}/${TARGET}

# generate list of Files for computation step.
[[ -e ${OUTPUT}/list.txt.${REFSTRUCT} ]] && rm ${OUTPUT}/list.txt.${REFSTRUCT}

# foreach image, create fuzzy landscape if not exist
(( NBIMG = 0 ))
foreach curimg (`cat ${IMGDB_HEALTHY}/listOfFiles.txt | xargs` `cat ${IMGDB_PATHOS}/listOfFiles.txt | xargs`)
#foreach curimg (`cat ${IMGDB_HEALTHY}/listOfFiles.txt | xargs`)
do
    IMGNAME=`basename $curimg`
    DBPATH=`dirname $curimg`
    echo "Generate relation map for "$curimg / ${REFSTRUCT} ${RELATION}

    # First, I need to extract REFSTRUCT and TARGET from the label map
    # Labels are those from the healthly and pathological database from /tsi/medical
    extractStructFromLabelMap $curimg $REFSTRUCT $TMPDIR
    extractStructFromLabelMap $curimg $TARGET    $TMPDIR
   # CUR_STRUCT_FILE=${TMPDIR}/${REFSTRUCT}/${IMGNAME}
    CUR_REF_FILE=${TMPDIR}/${REFSTRUCT}/${IMGNAME}
    CUR_TGT_FILE=${TMPDIR}/${TARGET}/${IMGNAME}

    #[[ -e ${CUR_STRUCT_FILE}_${RELATION} ]] || {
	# GenerateRelationMap ${CUR_STRUCT_FILE} ${RELATION} ${CUR_STRUCT_FILE}_${RELATION}
    #}

    #[[ -e ${CUR_REF_FILE} && -e ${CUR_TGT_FILE} ]] && {
        EvaluateRelation ${CUR_REF_FILE} ${REFSTRUCT} ${RELATION} ${CUR_TGT_FILE} ${TARGET}
    #}
    echo `basename ${curimg} .ima` >> ${OUTPUT}/list.txt.${REFSTRUCT}
    (( NBIMG = $NBIMG + 1 ))
done


