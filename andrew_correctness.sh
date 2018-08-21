#/bin/bash
# Script from JIRA ticket
# https://jira.mongodb.org/browse/SERVER-21336  & SCons bug 2980

git clean -xfd

cp --verbose ../mongo/${path_to_nodes}/{__init__.py,FS.py} ./${path_to_nodes}/

git checkout r3.7.1
/usr/bin/time python ./buildscripts/scons.py --ssl --link-model=dynamic --implicit-cache -j 12 --disable-warnings-as-errors --cache --build-fast-and-loose=on --modules= --variables-files= ./mongod
git checkout r3.7.2
/usr/bin/time python ./buildscripts/scons.py --ssl --link-model=dynamic --implicit-cache -j 12 --disable-warnings-as-errors --cache --build-fast-and-loose=on --modules= --variables-files= ./mongod
git checkout r3.7.1
/usr/bin/time python ./buildscripts/scons.py --ssl --link-model=dynamic --implicit-cache -j 12 --disable-warnings-as-errors --cache --build-fast-and-loose=on --modules= --variables-files= ./mongod 