# pfaedle eval

This is the evaluation workbench for pfaedle.

## Requirements

 * pdflatex
 * pfaedle installation
 * gnuplot

## How to use

Note: by default, a Gaussian noise with a standard deviation of 30 meters is added. To change this, set the variable `NOISE`. The number of runs the stats are averaged from can be set with the variable `RUNS`, the default is 50.

 * `make tables`: generates PDF result tables
 * `make plots`: generate overview plots
