#!/bin/bash
pushd noisepage > /dev/null
FILTER_DIR=$(realpath ../scripts/codestats/noisepage-filter)
QOpt_VAL=$(docker run -v $PWD:/data -v $FILTER_DIR:/filter cloc-docker --exclude-lang=CMake --json  --list-file=/filter/qopt.txt  | jq '[."C++".code, ."C/C++ Header".code] | add')
popd > /dev/null
echo "NoisePage QOpt ${QOpt_VAL}"