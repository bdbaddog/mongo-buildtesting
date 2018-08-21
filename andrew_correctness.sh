#/bin/bash
# Script from JIRA ticket
# https://jira.mongodb.org/browse/SERVER-21336  & SCons bug 2980

path_to_nodes=src/third_party/scons-2.5.0/scons-local-2.5.0/SCons/Node/
cores=8

git clean -xfd

cp --verbose ../mongo/${path_to_nodes}/{__init__.py,FS.py} ./${path_to_nodes}/

git checkout r3.7.1
/usr/bin/time python ./buildscripts/scons.py -j${cores} --ssl --link-model=dynamic --implicit-cache -j 12 --disable-warnings-as-errors --cache --build-fast-and-loose=on --modules= --variables-files= ./mongod 2>&1 | tee  ../BUILD.log.371.1 
git checkout r3.7.2
/usr/bin/time python ./buildscripts/scons.py -j${cores} --ssl --link-model=dynamic --implicit-cache -j 12 --disable-warnings-as-errors --cache --build-fast-and-loose=on --modules= --variables-files= ./mongod 2>&1 | tee  ../BUILD.log.372.1
git checkout r3.7.1
/usr/bin/time python ./buildscripts/scons.py -j${cores} --ssl --link-model=dynamic --implicit-cache -j 12 --disable-warnings-as-errors --cache --build-fast-and-loose=on --modules= --variables-files= ./mongod 2>&1 | tee  ../BUILD.log.371.2