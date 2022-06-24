#!/bin/bash
pushd duckdb > /dev/null
FILTER_DIR=$(realpath ../scripts/codestats/duckdb-filter)
RT_VAL=$(docker run -v $PWD:/data -v $FILTER_DIR:/filter cloc-docker --exclude-lang=CMake --json  --list-file=/filter/runtime.txt  | jq '[."C++".code, ."C/C++ Header".code] | add')
OP_VAL=$(docker run -v $PWD:/data -v $FILTER_DIR:/filter  cloc-docker --exclude-lang=CMake --json  --list-file=/filter/operator-impl.txt  | jq '[."C++".code, ."C/C++ Header".code] | add')
IR_VAL=$(docker run -v $PWD:/data -v $FILTER_DIR:/filter  cloc-docker --exclude-lang=CMake --json  --list-file=/filter/logical-operators.txt  | jq '[."C++".code, ."C/C++ Header".code] | add')

popd  > /dev/null
echo "DuckDB Runtime ${RT_VAL}"
echo "DuckDB IR ${IR_VAL}"
echo "DuckDB OperatorImpl ${OP_VAL}"