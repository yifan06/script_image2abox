#!/bin/zsh

# Generation of an observation using an ABox from an image 
# input image
 
DB_PATH="/data/yiyang/dataset/image/Brain"
TMP_STRUCT="./temp_structs" 
TMP_REL="./temp_relations"
source function_ima.zsh
source function.zsh

usage()
{
    echo " Generation of an ABox from an image"
    echo ""
    echo "./aboxGeneration.zsh"
    echo "\t-h --help"
    echo "\t-i --image <image (Tivoli)>"
    echo "\t"
    echo ""
}

# get all structures presenting in image
# extract all structures presented in the image and saved in a temporal folder temp_strus
extractAll()
{
	echo "IMG is $IMG"    
	[[ -e $TMP_STRUCT ]] || mkdir $TMP_STRUCT 
	IMG_PATH=`find $DB_PATH -name "$IMG.ima"`
        echo "img_path is $IMG_PATH"
	extractStructFromLabelMap $IMG_PATH WMl $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH GMl $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH LVl $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH THl $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH PUl $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH CDl $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH CDr $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH PUr $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH THr $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH LVr $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH GMr $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH WMr $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH tumor $TMP_STRUCT 
	extractStructFromLabelMap $IMG_PATH V3 $TMP_STRUCT 
}

evalRelations() {
	 # Using find or ls to get a list of .ima files in temporal folder and we cannot get a order list to combine all possible pairs of structures.
	 # So i decide to construct a hash map with the name of structure (concepts) and the associated files.
	 #LIST=`find $TMP_STRUCT -iname "*.ima"`
	 #echo $LIST
	
	 #LIST=`ls $TMP_STRUCT/*.ima`

	 #Declare a associated map 

	 #declare -A fileVarMap
	 # in zsh the decalartion is typeset
	 typeset -A fileVarMap
	 typeset -A fileDuplicate

	 for i in $TMP_STRUCT/*.ima 
	 do
			 curimg="$i"
			 fileWithExt=${curimg##*/}
			 echo $fileWithExt
			 concept=${fileWithExt%.*}
			 echo $concept
			 fileVarMap[${concept}]=$curimg
	 done
	 echo ${(k)fileVarMap}
	 echo ${(v)fileVarMap}

	 foreach key in ${(k)fileVarMap}
	 do
			 echo "key : $key"
			 echo "value : ${fileVarMap[$key]}"
	 done
	 fileDuplicate=("${(@kv)fileVarMap}")
	 foreach key in ${(k)fileDuplicate}
	 do
			 foreach key2 in ${(k)fileDuplicate}
	 		 do
					 [[ $key != $key2 ]] && {
			 			echo "key : $key"
			 			echo "key2 : $key2"
						[[ -e $TMP_REL ]] || {mkdir $TMP_REL}
						computeDirection ${fileDuplicate[$key]} $key ${fileDuplicate[$key2]} $key2 $TMP_REL
						}
			 done
			  # delete the combined element.
			  unset "fileDuplicate[$key]"
	 done
	 #echo ${fileVarMap[@]}
			 #Key=${!fileVarMap[*]}
			 #Value=${fileVarMap[*]}

			 #echo $Key
			 #echo $Value
	 # echo ${#LIST[@]}
	 #for (( ind1 = 0; ind1 <= ${#LIST[*]}; ind1++ ))
	 #do
	 #   	for (( ind2 = ind1+1; ind2<=${#LIST[*]}; ind2++ ))
	 #   	do
	 #   			tar=$LIST[ind1]
	 #   			ref=$LIST[ind2]
	 #   			echo $tar
	 #   			echo $ref
	 #   	done
	 #done
}
# call matlab script to evaluate intersection degree bewteen histogram of angles and direction fuzzy set
callMatlab() {
	# first of all, read all possible existing spatial relations in the temporal folder and execute one by one.
	# Or we can give matlab the folder path.
		matlab -nodisplay -nodesktop -nojvm -r "filepath='$TMP_REL/';try eval_direction(filepath); catch; end; quit"
}

# write all concepts in list to the xml file as the ABox
# write also evaluated spatial relations
output_ABox() {
	# read results from corresponding folders and creat an xml files.
    # output abox ontology owl file named after image name.	
	OUTABOX="${IMG}_abox.owl"
	[[ -e $OUTABOX ]] || {
	headOnto $OUTABOX
	# parsing relation files in temporal relation folder
	conceptIndOnto "eye" "Eye" $OUTABOX
	conceptIndOnto "nose" "Nose" $OUTABOX
	roleIndOnto "eye" "below" "nose" $OUTABOX
	footOnto $OUTABOX }
}
# option 1 get arguments with getopts
while getopts :i:h:hin:c: opt
do
    case $opt in
	i | -input)
	    echo $OPTARG
	    IMG=$OPTARG
	    extractAll
	    evalRelations
	    callMatlab
	   # output_ABox
	    ;;
	h | -help)
	    usage
	    exit;;
	*)
		usage
		;;
    esac 
done

# option 2 read arguments with shift and simple patterns
#while [[ $1 = -* ]]; do
#	case $1 in
#	  -i | --input)
#		IMG=$2
#		;;
#   	  -h | --help)
#		usage
#		exit;;
#	esac
#        shift
#done
 
echo "DB_PATH is $DB_PATH";
echo "IMG is $IMG";

# verify if the image given exists in the db_path
# IMG_PATH=`find $DB_PATH -iname $IMG`
# echo $IMG_PATH
#t_computeVolume -i $IMG_PATH



