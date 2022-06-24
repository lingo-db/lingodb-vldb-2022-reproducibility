# LingoDB Reproducibility Package

## Execution Environment
* Linux with the following tools installed:
  * standard tools (bash, csplit, cat, tail, make, sed, tail)
  * git
  * [jq](https://stedolan.github.io/jq/)
  * docker (installed to be used directly with the current user)

## Steps to reproduce

```bash
$ bash checkout.sh
...
$ bash reproduce.sh
...
Figure 9: plots/runtime.pdf
Figure 10: plots/compilation.pdf
Figure 11: plots/compilation-phases.pdf
Figure 12: plots/qopt-codestats.pdf
Figure 13: plots/exec-codestats.pdf
Figure 14:
unoptimized: results/linear-regression.mlir
after cross-domain optimization: results/linear-regression-optimized.mlir 
```
Afterward, have a look at the produced files in the directories `plots` and `results`.

