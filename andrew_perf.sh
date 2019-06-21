#/bin/bash
# Script from JIRA ticket
# https://jira.mongodb.org/browse/SERVER-21336?focusedCommentId=1964521&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-1964521
set -o verbose
set -o errexit

cores=8

_CommonArgs="--cache-dir=$(pwd)/cache VERBOSE=0 -j${cores} --implicit-cache --disable-warnings-as-errors --install-mode=hygienic --link-model=dynamic --allocator=system --js-engine=none --modules= --variables-files= --dbg=off --opt=size install-mobile-dev install-mobile-test"

plain_one=34de1953a9575f2745a1f430f5eb7ce2a6014031

# no scons patch, no cache, bfl=off
git checkout ${plain_one}
git clean -xfd
mkdir cache
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=off $_CommonArgs 2>&1 | tee ../base_nocache_nobfl_build.log
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=off $_CommonArgs 2>&1 | tee ../base_nocache_nobfl_rebuild.log

# no scons patch, no cache, bfl=on
git checkout ${plain_one}
git clean -xfd
mkdir cache
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=on $_CommonArgs 2>&1 | tee ../base_nocache_bfl_build.log
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=on $_CommonArgs 2>&1 | tee ../base_nocache_bfl_rebuild.log

# no scons patch, cache, bfl=off
git checkout ${plain_one}
git clean -xfd
mkdir cache
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=off --cache $_CommonArgs 2>&1 | tee ../base_cache_nobfl_build.log
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=off --cache $_CommonArgs 2>&1 | tee ../base_cache_nobfl_rebuild.log
\rm -rf build
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=off --cache $_CommonArgs 2>&1 | tee ../base_cache_nobfl_cacherebuild.log

# updated because target names changed
_CommonArgs="--cache-dir=$(pwd)/cache VERBOSE=0 -j${cores} --implicit-cache --disable-warnings-as-errors --install-mode=hygienic --link-model=dynamic --allocator=system --js-engine=none --modules= --variables-files= --dbg=off --opt=size install-mobile-dev install-mobile-test"
# scons patch, no cache, bfl=off
git checkout scons_2980_timestamp_md5_fix
git clean -xfd
mkdir cache
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=off $_CommonArgs 2>&1 | tee ../patch_nocache_nobfl_build.log
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=off $_CommonArgs 2>&1 | tee ../patch_nocache_nobfl_rebuild.log

# scons patch, no cache, bfl=on
git checkout scons_2980_timestamp_md5_fix
git clean -xfd
mkdir cache
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=on $_CommonArgs 2>&1 | tee ../patch_nocache_bfl_build.log
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=on $_CommonArgs 2>&1 | tee ../patch_nocache_bfl_rebuild.log

# scons patch, cache, bfl=off
git checkout scons_2980_timestamp_md5_fix
git clean -xfd
mkdir cache
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=off --cache $_CommonArgs 2>&1 | tee ../patch_cache_nobfl_build.log
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=off --cache $_CommonArgs 2>&1 | tee ../patch_cache_nobfl_rebuild.log
\rm -rf build
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=off --cache $_CommonArgs 2>&1 | tee ../patch_cache_nobfl_cacherebuild.log

# scons patch, cache, bfl=on

git checkout scons_2980_timestamp_md5_fix
git clean -xfd
mkdir cache
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=on --cache $_CommonArgs 2>&1 | tee ../patch_cache_bfl_build.log
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=on --cache $_CommonArgs 2>&1 | tee ../patch_cache_bfl_rebuild.log
\rm -rf build
/usr/bin/time python ./buildscripts/scons.py --build-fast-and-loose=on --cache $_CommonArgs 2>&1 | tee ../patch_cache_bfl_cacherebuild.log
