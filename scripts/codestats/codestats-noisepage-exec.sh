#!/bin/bash
pushd noisepage > /dev/null
FILTER_DIR=$(realpath ../scripts/codestats/noisepage-filter)
RT_VAL=$(docker run -v $PWD:/data -v $FILTER_DIR:/filter cloc-docker --exclude-lang=CMake --json  --list-file=/filter/runtime.txt  | jq '[."C++".code, ."C/C++ Header".code] | add')
OP_VAL=$(docker run -v $PWD:/data -v $FILTER_DIR:/filter cloc-docker --exclude-lang=CMake --json  --list-file=/filter/operator_impl.txt  | jq '[."C++".code, ."C/C++ Header".code] | add')
IR_VAL=$(docker run -v $PWD:/data -v $FILTER_DIR:/filter cloc-docker --exclude-lang=CMake --json  --list-file=/filter/ir.txt  | jq '[."C++".code, ."C/C++ Header".code] | add')
LOW_VAL=$(docker run -v $PWD:/data -v $FILTER_DIR:/filter cloc-docker --exclude-lang=CMake --json  --list-file=/filter/lowering.txt  | jq '[."C++".code, ."C/C++ Header".code] | add')

popd  > /dev/null
echo "NoisePage Runtime ${RT_VAL}"
echo "NoisePage IR ${IR_VAL}"
echo "NoisePage OperatorImpl ${OP_VAL}"
echo "NoisePage Lowering+Backend ${LOW_VAL}"