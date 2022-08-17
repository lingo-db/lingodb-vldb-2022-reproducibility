#!/bin/bash
git clone https://github.com/duckdb/duckdb.git duckdb
pushd duckdb
    git checkout 2aa4b87218717c16bcd6c65caaa68a7c4ff1483c
popd
git clone https://github.com/cmu-db/noisepage.git noisepage
pushd noisepage
    git checkout 79276e68fe83322f1249e8a8be96bd63c583ae56
popd
git clone https://github.com/lingo-db/lingo-db.git lingodb
pushd lingodb
    git checkout 1c39138ba34951b2ab8a60ee585bc82870ae5db9
popd
