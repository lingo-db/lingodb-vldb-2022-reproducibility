#!/bin/bash
pushd duckdb > /dev/null
FILTER_DIR=$(realpath ../scripts/codestats/duckdb-filter)
QOpt_VAL=$(docker run -v $PWD:/data -v $FILTER_DIR:/filter cloc-docker --exclude-lang=CMake --json  --list-file=/filter/qopt.txt  | jq '[."C++".code, ."C/C++ Header".code] | add')
popd  > /dev/null
echo "DuckDB QOpt ${QOpt_VAL}"