#!/bin/bash

IR_INCL_DIRS="lingodb/include/mlir/Dialect/RelAlg lingodb/lib/RelAlg lingodb/include/mlir/Dialect/DB lingodb/include/mlir/Dialect/DSA lingodb/lib/DB lingodb/lib/DB/Transforms lingodb/lib/DSA lingodb/include/mlir/Dialect/util lingodb/lib/util"
IR_EXCL_DIRS="Transforms"

OP_INCL_DIRS="lingodb/include/mlir/Conversion/RelAlgToDB"
LOW_INCL_DIRS="lingodb/include/mlir/Conversion/DBToArrowStd lingodb/lib/Conversion/DBToArrowStd lingodb/include/mlir/Conversion/DSAToStd lingodb/lib/Conversion/DSAToStd lingodb/include/mlir/Conversion/UtilToLLVM lingodb/lib/Conversion/UtilToLLVM lingodb/include/runner lingodb/lib/runner"
RT_INCL_DIRS="lingodb/include/runtime lingodb/lib/runtime"
IR_VAL=$(docker run -v $PWD:/data cloc-docker --exclude-lang=CMake --json --force-lang-def=scripts/codestats/cloc.defs --exclude-dir=$IR_EXCL_DIRS $IR_INCL_DIRS  | jq '[."C++".code, ."C/C++ Header".code, ."TableGen".code] | add')
OP_VAL=$(docker run -v $PWD:/data cloc-docker --exclude-lang=CMake --json --force-lang-def=scripts/codestats/cloc.defs  $OP_INCL_DIRS  | jq '[."C++".code, ."C/C++ Header".code, ."TableGen".code] | add')
LOW_VAL=$(docker run -v $PWD:/data cloc-docker --exclude-lang=CMake --json --force-lang-def=scripts/codestats/cloc.defs  $LOW_INCL_DIRS  | jq '[."C++".code, ."C/C++ Header".code, ."TableGen".code] | add')
RT_VAL=$(docker run -v $PWD:/data cloc-docker --exclude-lang=CMake --json --force-lang-def=scripts/codestats/cloc.defs  $RT_INCL_DIRS  | jq '[."C++".code, ."C/C++ Header".code, ."TableGen".code] | add')

echo "LingoDB IR ${IR_VAL}"
echo "LingoDB OperatorImpl ${OP_VAL}"
echo "LingoDB Lowering+Backend ${LOW_VAL}"
echo "LingoDB Runtime ${RT_VAL}"