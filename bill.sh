#/bin/bash
# Script from JIRA ticket
# https://jira.mongodb.org/browse/SERVER-21336?focusedCommentId=1964521&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-1964521
set -o verbose
set -o errexit

_CommonArgs="--cache-dir=$(pwd)/cache VERBOSE=0 -j12 --implicit-cache --disable-warnings-as-errors --install-mode=hygienic --link-model=dynamic --allocator=system --js-engine=none --modules= --variables-files= --dbg=off --opt=size install-mobile-dev install-mobile-test"

path_to_nodes=src/third_party/scons-2.5.0/scons-local-2.5.0/SCons/Node/

# scons patch, cache, bfl=on
git checkout r3.7.1
git clean -xfd
cp --verbose ../mongo/${path_to_nodes}/{__init__.py,FS.py} ./${path_to_nodes}/
mkdir cache

/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=on --cache $_CommonArgs 2>&1 | tee ../patch_cache_bfl_build.log
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=on --cache $_CommonArgs 2>&1 | tee ../patch_cache_bfl_rebuild.log
\rm -rf build
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=on --cache $_CommonArgs 2>&1 | tee ../patch_cache_bfl_cacherebuild.log
