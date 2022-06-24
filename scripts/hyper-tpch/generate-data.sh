#!/usr/bin/env bash
set -euo pipefail
TMPDIR=`mktemp --directory`
pushd $TMPDIR
wget -q https://github.com/electrum/tpch-dbgen/archive/32f1c1b92d1664dba542e927d23d86ffa57aa253.zip -O tpch-dbgen.zip
unzip -q tpch-dbgen.zip
mv tpch-dbgen-32f1c1b92d1664dba542e927d23d86ffa57aa253/* .
rm tpch-dbgen.zip
make
set -x
./dbgen -f -s 1
for table in ./*.tbl; do  sed -i 's/|$//' "$table"; cp $table /tpch-data-1; done
./dbgen -f -s 10
for table in ./*.tbl; do  sed -i 's/|$//' "$table"; cp $table /tpch-data-10; done
popd
