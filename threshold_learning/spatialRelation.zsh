
# GenerateAngleMap input direction
# generate an angle map image using the input image and the direction.
#  - input is an U8 volume in IMA format.
#  - Direction is one of : Left Right InFront Behind Up Down
#  - output is name accordingly to input and direction following:
#         ${INPUT}_angle_${DIRECTION}
GenerateAngleMap3() {
    checkNbParam 3 $*

    #echo "Generate angle map on direction: "${2}" using: \n\t"${T_ANGLE}

    INPUT_ANGLE=$1
    DIRECTION=$2
    OUTPUT_ANGLE=$3

   # T_ANGLE=${TIVOLI_BIN}/t_angleVisiblePropag2
    T_ANGLE=t_angleVisiblePropag2

    # 1: left, 2: right, 3: in front of, 4: behind, 5: above, 6: below
    case $DIRECTION in
	Left)    DIR=1 ; DIRINV=2 ;;
	Right)   DIR=2 ; DIRINV=1 ;;
	InFront) DIR=3 ; DIRINV=4 ;;
	Behind)  DIR=4 ; DIRINV=3 ;;
	Up)      DIR=5 ; DIRINV=6 ;;
	Down)    DIR=6 ; DIRINV=5 ;;
	*) echo "error, unknown direction pattern"; exit -1 ;;
    esac

    [[ -e ${OUTPUT_ANGLE}.dim ]] || {
	# verify if input exist
	checkImaFiles ${INPUT_ANGLE}
	# generate angle map
	echo ${T_ANGLE} -i ${INPUT_ANGLE} -o ${OUTPUT_ANGLE} -d ${DIR}
	${T_ANGLE} -i ${INPUT_ANGLE} -o ${OUTPUT_ANGLE} -d ${DIR} > /dev/null 2>&1
    }
}

# GenerateAngleMap input direction
# generate an angle map image using the input image and the direction.
#  - input is an U8 volume in IMA format.
#  - Direction is one of : LeftOf RightOf InFrontOf BehindOf UpOf DownOf
#  - output is name accordingly to input and direction following:
#         ${INPUT}_angle_${DIRECTION}
GenerateAngleMapItk() {
    checkNbParam 3 $*

    #echo "Generate angle map on direction: "${2}" using: \n\t"${T_ANGLE}

    INPUT_ANGLE=$1
    DIRECTION=$2
    OUTPUT_ANGLE=$3

    #T_ANGLE2=/tsi/bikaner2/atif/SpatialLearning/code/RelationsSpatiales/bin/t_angle
    #/tsi/benares2/fouquier/search/RelationsSpatiales/bin/t_angle
    #T_ANGLE2=${TIVOLI_BIN}/t_angle
    export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/tsi/bidar2/fouquier/learn/ITK/oldinstall/lib/InsightToolkit:/goa/scratch/fouquier/ITK/oldinstall/lib/
    T_ANGLE=/tsi/bidar2/fouquier/learn/ITK/oldbuild/SmallUtils/itk_RelativePosition

    # 1: left, 2: right, 3: in front of, 4: behind, 5: above, 6: below
    case $DIRECTION in
	Left)    DIR="-l" ;;
	Right)   DIR="-r" ;;
	InFront) DIR="-f" ;;
	Behind)  DIR="-q" ;;
	Up)      DIR="-u" ;;
	Down)    DIR="-d" ;;
	*) echo "error, unknown direction pattern"; exit -1 ;;
    esac

    [[ -e ${OUTPUT_ANGLE}.dim ]] || {
	# verify if input exist
	checkImaFiles ${INPUT_ANGLE}
	# generate angle map
	AimsFileConvert -i ${INPUT_ANGLE} -o ${INPUT_ANGLE}.img > /dev/null 2>&1
	${T_ANGLE} -i ${INPUT_ANGLE}.img -o ${OUTPUT_ANGLE}_float.img -s ${DIR} > /dev/null 2>&1
	AimsFileConvert -i ${OUTPUT_ANGLE}_float.img -t U8 -o ${OUTPUT_ANGLE}.ima -r > /dev/null 2>&1
    }
}

# GenerateAngleMap input direction
# generate an angle map image using the input image and the direction.
#  - input is an U8 volume in IMA format.
#  - Direction is one of : LeftOf RightOf InFrontOf BehindOf UpOf DownOf
#  - output is name accordingly to input and direction following:
#         ${INPUT}_angle_${DIRECTION}
GenerateAngleMap2() {
    checkNbParam 2 $*

    INPUT_ANGLE=$1
    DIRECTION=$2
    OUTPUT_ANGLE=${INPUT_ANGLE}"_angle_"${DIRECTION}

    GenerateAngleMap3 ${INPUT_ANGLE} ${DIRECTION} ${OUTPUT_ANGLE}
}

GenerateAngleMap() {
    [[ $# -eq 2 ]] && {
	GenerateAngleMap2 $*
	return
    }
    [[ $# -eq 3 ]] && {
	GenerateAngleMap3 $*
	return
    }
    echo -n "error: need 2 or 3 parameters in input instead of "$#", exit"
    exit -1
}


# GenerateDistanceMap input
# generate a distance map using input image
#  - input is an U8 volume in IMA format.
#  - output is name accordingly to input and direction following:
#         ${INPUT}_distance
GenerateDistanceMap() {
    checkNbParam 2 $*

    INPUTIMAGE=${1}
    DISTANCEIMA=${2}

    [[ -e ${DISTANCEIMA}.ima ]] || {
	checkImaFiles ${INPUTIMAGE}
	echo "Generate distance map for "$1
#	${T_DIST} -i ${INPUTIMAGE} -o ${DISTANCEIMA}
	t_distance -i ${INPUTIMAGE} -o ${DISTANCEIMA}
    }
}

GenerateSymetryMap() {
    checkNbParam 2 $*

    INPUTIMAGE=${1}
    SYMETRYIMA=${2}

    [[ -e ${SYMETRYIMA}.ima ]] || {
	checkImaFiles ${INPUTIMAGE}
	echo "Generate symetry map for "$1
	t_flipx -i ${INPUTIMAGE} -o /tmp/tmpflip
	t_structuringElement -o /tmp/se -t 2 -p1 5 -p2 2 -v 255 -nx 100 -ny 100 -nz 100 -cx 50 -cy 50 -cz 50
	t_fuzzyMorpho -i /tmp/tmpflip -se /tmp/se -o ${SYMETRYIMA} -t 1 -n 1
    }
}

GenerateRelationMap() {

    [[ $# -lt 2 ]] && {
	   echo -n "error: need 2 or 3 parameters in input instead of "$#", exit"
	   exit -1
    }

    RELATION=${2}

    case ${RELATION} in
	Distance|Near|Adjacent) GenerateDistanceMap $1 ${1}_Distance
        ;;
	Left|Right|Up|Down|InFront|Behind) GenerateAngleMap $*
        ;;
	Symetry) GenerateSymetryMap $1 ${1}_Symetry
    esac

#    [[ ${RELATION} == "Distance" ]] && {
#	GenerateDistanceMap $1 ${1}_Distance
#    } || {
#	[[ ${RELATION} == "Near" ]] && {
#	    GenerateDistanceMap $1 ${1}_Distance
#	} || {
#	    [[ ${RELATION} == "Near" ]] && {
#		GenerateDistanceMap $1 ${1}_Distance
#	    } || {
#	    GenerateAngleMap $*
#	}
#    }

}
EvaluateDistance(){
	TAR=$1
	REF=$4
	TARNAME=$2
	REFNAME=$5
	IMGNAME=`basename $TAR`
	TARPATH=`dirname $TAR`
	REFPATH=`dirname $REF`
        RESULTPATH="/data/yiyang/sr_threshold_histo/results/"
	TEMP_DIR="/data/yiyang/sr_threshold_histo/results/temp"
	
	case ${3} in
	Distance) FILEMIN="farfrom_min.txt"
		  FILEHAU="farfrom_haussdorf.txt"
        ;;
	Near) FILEMIN="closeto_min.txt"
	      FILEHAU="closeto_haussdorf.txt"
        ;;
    	esac

        RESULTMIN="${RESULTPATH}${FILEMIN}"
        RESULTHAU="${RESULTPATH}${FILEHAU}"

	[[ -e ${RESULT} ]] || touch ${RESULT}
	[[ -d ${TEMP_DIR} ]] || mkdir ${TEMP_DIR}
	   
	    REFDIST="${REFNAME}_dist"
	    TARDIST="${TARNAME}_dist"
	    REFMASK="${REFNAME}_mask"
	    TARMASK="${TARNAME}_mask"
	    REFMASKIF="${REFNAME}_maskinvfond"
	    TARMASKIF="${TARNAME}_maskinvfond"
	     
	    [[ -e ${TEMP_DIR}/${REFDIST} ]] || t_distance -i ${REF} -o ${TEMP_DIR}/${REFDIST}
	    [[ -e ${TEMP_DIR}/${TARDIST} ]] || t_distance -i ${TAR} -o ${TEMP_DIR}/${TARDIST}
		 
	    t_mask -i ${TEMP_DIR}/${REFDIST} -r ${TAR} -o ${TEMP_DIR}/${TARMASK}
	    t_mask -i ${TEMP_DIR}/${TARDIST} -r ${REF} -o ${TEMP_DIR}/${REFMASK}
	    MAXDISTTR=`t_minmax ${TEMP_DIR}/${TARMASK} | grep "Maximum" |  cut -d' ' -f 3`
	    MAXDISTRT=`t_minmax ${TEMP_DIR}/${REFMASK} | grep "Maximum" | cut -d' ' -f 3`

	    t_changeLevel -i ${TEMP_DIR}/${REFMASK} -l 0 -n 255 -o ${TEMP_DIR}/${REFMASKIF}
	    t_changeLevel -i ${TEMP_DIR}/${TARMASK} -l 0 -n 255 -o ${TEMP_DIR}/${TARMASKIF}
	    MINDISTTR=`t_minmax ${TEMP_DIR}/${TARMASKIF} | grep "Minimum" | cut -d' ' -f 3`
	    MINDISTRT=`t_minmax ${TEMP_DIR}/${REFMASKIF} | grep "Minimum" | cut -d' ' -f 3`

	    
	    echo 'maxdisttr' ${MAXDISTTR}
	    echo 'maxdistrt' ${MAXDISTRT}
	    echo 'mindisttr' ${MINDISTTR}
	    echo 'mindistrt' ${MINDISTRT}
	   
	    [[ ${MAXDISTTR} > ${MAXDISTRT} ]] && HAUSSDORF=${MAXDISTTR} || HAUSSDORF=${MAXDISTRT}
	    #echo 'min_distance:' ${MINDISTRT} 'haussdorf_distance:' ${HAUSSDORF}  > ${TEMP_DIR}/${DISTANCE}

	echo ${MINDISTRT}  >> ${RESULTMIN}      
	echo ${HAUSSDORF}  >> ${RESULTHAU}
	
        t_rm ${TEMP_DIR}/${REFDIST}
        t_rm ${TEMP_DIR}/${TARDIST}
         t_rm ${TEMP_DIR}/${TARMASK}
         t_rm ${TEMP_DIR}/${REFMASK}
         t_rm ${TEMP_DIR}/${REFMASKIF}
         t_rm ${TEMP_DIR}/${TARMASKIF}

}
EvaluateAngleHisto(){
	TAR=$1
	REF=$4
	TARNAME=$2
	REFNAME=$5
	IMGNAME=`basename $TAR`
	TARPATH=`dirname $TAR`
	REFPATH=`dirname $REF`
        RESULTPATH="/data/yiyang/sr_threshold_histo/results/"
	TEMP_DIR="/data/yiyang/sr_threshold_histo/results/temp_dir/"

	[[ -d ${TEMP_DIR} ]] || mkdir ${TEMP_DIR}
	[[ -d ${TEMP_DIR}${3} ]] || mkdir ${TEMP_DIR}${3} 
	
	histoAngle3d=/data/yiyang/software/tivoli-1.3.1/libtivoli/bin/t_histoAngle3d
	#case ${3} in
	#Right) [[ -d ${TEMP_DIR}${3} ]] || mkdir ${TEMP_DIR}${3} 
        #;;
	#Left) [[ -d ${TEMP_DIR}${3} ]] || mkdir ${TEMP_DIR}${3} 
        #;;
	#InFront) [[ -d ${TEMP_DIR}${3} ]] || mkdir ${TEMP_DIR}${3} 
	#;;
	#Behind) [[ -d ${TEMP_DIR}${3} ]] || mkdir ${TEMP_DIR}${3} 
	#;;
	#Up) [[ -d ${TEMP_DIR}${3} ]] || mkdir ${TEMP_DIR}${3} 
	#;;
	#Down) [[ -d ${TEMP_DIR}${3} ]] || mkdir ${TEMP_DIR}${3} 
    	#esac

        #RESULTMIN="${RESULTPATH}${FILEMIN}"
        #RESULTHAU="${RESULTPATH}${FILEHAU}"
	#t_histoAngle3d -i1 ${TAR} -i2 ${REF} -o ${TEMP_DIR}${3}/${TARNAME}_${REFNAME}_${IMGNAME}.txt
	${histoAngle3d} -i1 ${TAR} -i2 ${REF} -o ${TEMP_DIR}${3}/${TARNAME}_${REFNAME}_${IMGNAME}.txt

}


EvaluateRelation() {

    [[ $# -lt 5 ]] && {
	   echo -n "error: need  5 parameters in input instead of "$#", exit"
	   exit -1
    }

    RELATION=${3}

    case ${RELATION} in
	Distance|Near|Adjacent) EvaluateDistance $*
        ;;
	Left|Right|Up|Down|InFront|Behind) EvaluateAngleHisto $*
        ;;
    esac
}

