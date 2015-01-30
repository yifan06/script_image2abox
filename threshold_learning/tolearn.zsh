#!/bin/zsh

LOCALREP=`pwd`

LIST_NEAR=/data/yiyang/sr_threshold_histo/list_closeto.txt
LIST_DISTANCE=/data/yiyang/sr_threshold_histo/list_farfrom.txt
LIST_RIGHT=/data/yiyang/sr_threshold_histo/list_right.txt
LIST_LEFT=/data/yiyang/sr_threshold_histo/list_left.txt
LIST_UP=/data/yiyang/sr_threshold_histo/list_up.txt
LIST_DOWN=/data/yiyang/sr_threshold_histo/list_down.txt
LIST_INFRONT=/data/yiyang/sr_threshold_histo/list_infront.txt
LIST_BEHIND=/data/yiyang/sr_threshold_histo/list_behind.txt


COMPUTEREL=${LOCALREP}/computeRelation.zsh

# read word by word separated with blank from a file
#foreach relation (`cat ${LIST_NEAR} | xargs`)
#do
#	echo ${relation}
#done

disthisto(){
	line=$1
	flag=0
	foreach word (`echo ${relation} | xargs`)
	do
		[[ ${flag} == 0 ]] && TGT=${word}
		[[ ${flag} == 1 ]] && REL=${word}
		[[ ${flag} == 2 ]] && REF=${word}
		(( flag = ${flag} + 1 ))
	done
	echo ${TGT}
	echo ${REL}
	echo ${REF}
	#${COMPUTEREL} ${TGT} ${REL} ${REF} 
	${COMPUTEREL} ${TGT} ${REL} ${REF} > log.${TGT}_${REL}_${REF}.txt 2>&1
        tail log.${TGT}_${REL}_${REF}.txt
}


# read line by line from a file
#while read relation
#do
#	#echo ${relation}
#	disthisto ${relation}
#done < ${LIST_RIGHT}
#
while read relation
do
	#echo ${relation}
	disthisto ${relation}
done < ${LIST_LEFT}
#
#while read relation
#do
#	#echo ${relation}
#	disthisto ${relation}
#done < ${LIST_UP}
#
#while read relation
#do
#	#echo ${relation}
#	disthisto ${relation}
#done < ${LIST_DOWN}

#while read relation
#do
#	#echo ${relation}
#	disthisto ${relation}
#done < ${LIST_INFRONT}

#while read relation
#do
#	#echo ${relation}
#	disthisto ${relation}
#done < ${LIST_BEHIND}

#
#while read relation
#do
#	#echo ${relation}
#	disthisto ${relation}
#done < ${LIST_DISTANCE}



learnDirThreshold(){
    LSRC=$1
    LREL=$2
    LTGT=$3

    echo ${LSRC} ${LREL} ${LTGT}
    echo
    DIRSCRIPT=${LOCALREP}/dirhisto.zsh
    ${LEARNSCRIPT} ${LSRC} ${LREL} ${LTGT} > dir.${LSRC}_${LREL}_${LTGT}.txt 2>&1
    tail dir.${LSRC}_${LREL}_${LTGT}.txt
    echo
}

learnDistThreshold(){
    LSRC=$1
    LREL=$2
    LTGT=$3

    echo ${LSRC} ${LREL} ${LTGT}
    echo
    DISTSCRIPT=${LOCALREP}/disthisto.zsh
    ${LEARNSCRIPT} ${LSRC} ${LREL} ${LTGT} > dist.${LSRC}_${LREL}_${LTGT}.txt 2>&1
    tail dist.${LSRC}_${LREL}_${LTGT}.txt
    echo
}
