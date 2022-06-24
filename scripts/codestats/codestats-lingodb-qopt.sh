#!/bin/bash

QOPT_INCL_DIRS="lingodb/include/mlir/Dialect/RelAlg/Transforms lingodb/lib/RelAlg/Transforms"
QOpt_VAL=$(docker run -v $PWD:/data cloc-docker --exclude-lang=CMake --json --force-lang-def=scripts/codestats/cloc.defs $QOPT_INCL_DIRS  | jq '[."C++".code, ."C/C++ Header".code, ."TableGen".code] | add')

echo "LingoDB QOpt ${QOpt_VAL}"