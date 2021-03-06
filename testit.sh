#!/bin/bash

set -e
set -x

END=2 # 10
DATE=`date +"%Y_%M_%d_%H_%m_%S"`
LOGDIR=../logs/${DATE}
mkdir -p ${LOGDIR}

#/usr/bin/time python buildscripts/scons.py -j 10 --variables-files=./etc/scons/mongodbtoolchain_stable_gcc.vars --ssl --implicit-cache --disable-warnings-as-errors --modules= --build-fast-and-loose=off --link-model=dynamic  2>&1 | tee ${LOGDIR}/BUILD.log

for i in $(seq 1 $END); do
    echo $i;
    /usr/bin/time python buildscripts/scons.py -j 10 --variables-files=./etc/scons/mongodbtoolchain_stable_gcc.vars --ssl --implicit-cache --disable-warnings-as-errors --modules= --build-fast-and-loose=on --link-model=dynamic  --debug=explain 2>&1 | tee ${LOGDIR}/REBUILD.bfl.${i}
    /usr/bin/time python buildscripts/scons.py -j 10 --variables-files=./etc/scons/mongodbtoolchain_stable_gcc.vars --ssl --implicit-cache --disable-warnings-as-errors --modules= --build-fast-and-loose=off --link-model=dynamic  --debug=explain 2>&1 | tee ${LOGDIR}/REBUILD.nobfl.${i}
done


echo "Build Fast Loose average"
#grep user ${LOGDIR}/REBUILD.bfl.{?,??} | sed 's/user.*//' | awk '{ total += $1; count++ } END { print total/count }'
grep user ${LOGDIR}/REBUILD.bfl.{?,??} | sed 's/^[^:]*://g' | sed 's/user.*//' | awk '{ total += $1; count++ } END { print total/count }'

echo "No Build Fast Loose average"
grep user ${LOGDIR}/REBUILD.nobfl.{?,??} | sed 's/^[^:]*://g' | sed 's/user.*//' | awk '{ total += $1; count++ } END { print total/count }'
#grep user ${LOGDIR}/REBUILD.nobfl.{?,??} |  sed 's/user.*//' | awk '{ total += $1; count++ } END { print total/count }'

