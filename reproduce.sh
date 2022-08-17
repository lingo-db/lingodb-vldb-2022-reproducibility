#!/bin/bash
rm -rf results
mkdir -p results
pushd lingodb
make reproduce > ../results/lingodb-execution.log
popd
pushd results
csplit lingodb-execution.log "/#Query/"
mv xx00 tpch-results.txt
echo '       query        time          opt           db          std          llvm   conversion      compile        error'> tpch-times.csv
#add everything from old file starting from second line
cat xx01 |tail -n+2>> tpch-times.csv
popd


docker build -t hyper-benchmark -fscripts/hyper-tpch/Dockerfile .

docker run --privileged -it hyper-benchmark /bin/bash -c "python3 hyper-script/benchmark.py /tpch-data-1" > results/hyper-tpch-1.log
docker run --privileged -it hyper-benchmark /bin/bash -c "python3 hyper-script/benchmark.py /tpch-data-10" > results/hyper-tpch-10.log


docker build -t duckdb-benchmark -fscripts/duckdb-tpch/Dockerfile .

docker run --privileged -it duckdb-benchmark /bin/bash -c "./build/release/benchmark/benchmark_runner --threads=1 \"benchmark/tpch/sf1/.*\"" > results/duckdb-tpch-1.log

sed -i 's/\.benchmark//' results/duckdb-tpch-1.log
sed -i 's/benchmark\/tpch\/sf1\/q0/Q/' results/duckdb-tpch-1.log
sed -i 's/benchmark\/tpch\/sf1\/q/Q/' results/duckdb-tpch-1.log

docker build -t cloc-docker -f scripts/codestats/Dockerfile .
echo "System Component LoC" >> results/exec-codestats.csv
echo "System Component LoC" >> results/qopt-codestats.csv

bash scripts/codestats/codestats.sh

docker build -t r-plot -fscripts/plots/Dockerfile .

rm -rf plots
mkdir -p plots
docker run -v $PWD/plots:/output -it r-plot /bin/bash -c "Rscript /plot-scripts/plot-runtime.r"
docker run -v $PWD/plots:/output -it r-plot /bin/bash -c "Rscript /plot-scripts/plot-compilation.r"
docker run -v $PWD/plots:/output -it r-plot /bin/bash -c "Rscript /plot-scripts/plot-compilation-phases.r"
docker run -v $PWD/plots:/output -it r-plot /bin/bash -c "Rscript /plot-scripts/plot-exec-locs.r"
docker run -v $PWD/plots:/output -it r-plot /bin/bash -c "Rscript /plot-scripts/plot-qopt-locs.r"


docker run --privileged -it lingodb-repr /bin/bash -c "/build/lingodb/mlir-db-opt test/lit/pytorch/linear-regression.mlir" > results/linear-regression.mlir
docker run --privileged -it lingodb-repr /bin/bash -c "/build/lingodb/mlir-db-opt --torch-backend-to-linalg-on-tensors-backend-pipeline --canonicalize --inline --scf-bufferize --linalg-bufferize --refback-munge-memref-copy --func-bufferize --arith-bufferize --tensor-bufferize -finalizing-bufferize --refback-insert-rng-globals --convert-linalg-to-affine-loops --affine-loop-fusion --affine-loop-unroll=\"unroll-full unroll-num-reps=3\" --affine-scalrep --canonicalize --lower-affine --canonicalize  --simplify-memrefs --db-simplify-to-arith --simplify-arithmetics --canonicalize  -symbol-privatize=\"exclude=main\" --symbol-dce test/lit/pytorch/linear-regression.mlir" > results/linear-regression-optimized.mlir

#todo

echo "===================== Reproduced Figures ====================="

echo "Figure 9: plots/runtime.pdf"
echo "Figure 10: plots/compilation.pdf"
echo "Figure 11: plots/compilation-phases.pdf"
echo "Figure 12: plots/qopt-codestats.pdf"
echo "Figure 13: plots/exec-codestats.pdf"
echo "Figure 14:"
echo "unoptimized: results/linear-regression.mlir"
echo "after cross-domain optimization: results/linear-regression-optimized.mlir "

