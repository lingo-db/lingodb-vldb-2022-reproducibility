#!/bin/bash
bash scripts/codestats/codestats-lingodb-exec.sh >> results/exec-codestats.csv
bash scripts/codestats/codestats-duckdb-exec.sh >> results/exec-codestats.csv
bash scripts/codestats/codestats-noisepage-exec.sh >> results/exec-codestats.csv

bash scripts/codestats/codestats-lingodb-qopt.sh >> results/qopt-codestats.csv
bash scripts/codestats/codestats-duckdb-qopt.sh >> results/qopt-codestats.csv
bash scripts/codestats/codestats-noisepage-qopt.sh >> results/qopt-codestats.csv