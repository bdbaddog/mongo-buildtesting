#/bin/bash
# Script from JIRA ticket
# https://jira.mongodb.org/browse/SERVER-21336  & SCons bug 2980

set -e
set -x


path_to_nodes=src/third_party/scons-2.5.0/scons-local-2.5.0/SCons/Node/
cores=8

# Linux
#flags="-j${cores} --ssl --link-model=dynamic --implicit-cache -j 12 --disable-warnings-as-errors --cache --build-fast-and-loose=on --modules= --variables-files= --debug=explain"

# MacOS
flags="-j${cores} --link-model=dynamic --implicit-cache -j 12 --disable-warnings-as-errors --cache --build-fast-and-loose=on --modules= --variables-files= --cache-debug=- --debug=explain"
# flags="-j${cores} --link-model=dynamic --implicit-cache -j 12 --disable-warnings-as-errors --cache --build-fast-and-loose=off --modules= --variables-files= --debug=explain"
flags="-j${cores} --link-model=dynamic  -j 12 --disable-warnings-as-errors --cache --build-fast-and-loose=on --modules= --variables-files=etc/scons/xcode_macosx.varsg --cache-debug=- --debug=explain"


log_dir=../logs
mkdir -p ${log_dir}

target=build/cached/mongo/base/global_initializer.os
# target=./mongod
revision=nic.1

git clean -xfd

cp -v ../mongo/${path_to_nodes}/{__init__.py,FS.py} ./${path_to_nodes}/

git checkout r3.7.1
/usr/bin/time python ./buildscripts/scons.py ${flags} ${target} 2>&1 | tee  ${log_dir}/BUILD.log.371.${revision}.1

# capture sconsign info
python src/third_party/scons-2.5.0/sconsign.py -e global_initializer.os build/scons/sconsign.dblite > ${log_dir}/CSIG.${revision}.1 2>&1
 
git checkout r3.7.2
/usr/bin/time python ./buildscripts/scons.py ${flags} ${target} 2>&1 | tee  ${log_dir}/BUILD.log.372.${revision}.1

# capture sconsign info
python src/third_party/scons-2.5.0/sconsign.py -e global_initializer.os build/scons/sconsign.dblite > ${log_dir}/CSIG.${revision}.2 2>&1

git checkout r3.7.1
/usr/bin/time python ./buildscripts/scons.py ${flags} ${target} 2>&1 | tee  ${log_dir}/BUILD.log.371.${revision}.2

# capture sconsign info
python src/third_party/scons-2.5.0/sconsign.py -e global_initializer.os build/scons/sconsign.dblite > ${log_dir}/CSIG.${revision}.3 2>&1

# check results . Should be zero g++ -c's
grep g++ ${log_dir}/BUILD.log.371.2 | grep -- "-c " | wc

# post process for
grep CDSIG ${log_dir}/BUILD.log.371.nic.1.1 | grep global_initializer | sed 's/^.*->/sig_371_1 =/' > CDSIG.py
grep CDSIG ${log_dir}/BUILD.log.372.nic.1.1 | grep global_initializer | sed 's/^.*->/sig_372_1 =/' >> CDSIG.py
grep CDSIG ${log_dir}/BUILD.log.371.nic.1.2 | grep global_initializer | sed 's/^.*->/sig_371_2 =/' >> CDSIG.py
