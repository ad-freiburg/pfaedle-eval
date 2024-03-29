# pfaedle eval

This is the evaluation workbench for [pfaedle](https://github.com/ad-freiburg/pfaedle).

## Requirements

 * pdflatex
 * pfaedle installation
 * gnuplot

## How to use

 * `make help`: Show help (this file)
 * `make check`: generate overview plots.
 * `make tables`: Generates PDF result tables
 * `make plots`: Generate overview plots.

Note: by default, a Gaussian noise with a standard deviation of 30 meters is added. To change this, set the variable `NOISE`. The number of runs the stats are averaged from can be set with the variable `RUNS`, the default is 50.

## Run with Docker

Build the container:

    $ docker build -t pfaedle-eval .

Run the evaluation:

    $ docker run pfaedle-eval <TARGET>

where `<TARGET>` is the Makefile target,  either `tables` or `plots` (see above).

Evaluation results will be output to `/output` inside the container. To retrieve them, mount `/output` to a local folder:

    $ docker run -v /local/folder/:/output pfaedle-eval <TARGET>
