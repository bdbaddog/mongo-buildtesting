#/bin/bash
# Script from JIRA ticket
# https://jira.mongodb.org/browse/SERVER-21336  & SCons bug 2980

set -e
set -x


path_to_nodes=src/third_party/scons-2.5.0/scons-local-2.5.0/SCons/Node/
cores=8

plat=$(uname)


path_to_nodes=src/third_party/scons-2.5.0/scons-local-2.5.0/SCons/Node/
cores=8


if [ "$plat" == "Darwin" ]
then
    #MacOS
    flags="-j${cores} --link-model=dynamic --disable-warnings-as-errors --cache --build-fast-and-loose=on --modules= --variables-files=etc/scons/xcode_macosx.varsg --cache-debug=- --debug=explain"
else
    # Linux
    flags="-j${cores} --ssl --link-model=dynamic --implicit-cache  --disable-warnings-as-errors --cache --build-fast-and-loose=on --modules= --variables-files= --debug=explain"
fi

log_dir=../logs
mkdir -p ${log_dir}

target=build/cached/mongo/base/global_initializer.os
<<<<<<< HEAD
# target=./mongod
#target="install-mobile-dev install-mobile-test"

=======
target=./mongod
>>>>>>> 6827e679347c277a871a5b2aef569b34d79462e8
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
