set key noautotitle

set zrange [0:1]
set yrange [0:13]
set xrange [0:130]
set xyplane at -0.05

set xtics offset -0.5,-0.5
set ytics offset 0.5,-0.5
set ztics offset 1.5,0

set ytics ("2" 1, 2, "8" 3, "32" 5, "128" 7,  "512" 9,  "2048" 11, "8192" 13)
set xtics ("10" 10, "30" 30, "50" 50, "70" 70,  "90" 90,  "110" 110, "130" 130)

set ylabel label

set xlabel "$\\sigma$"

set zlabel "$A_N^{10}$"

set pm3d interpolate 2,2
set dgrid3d 14,14 gauss 6.7,0.67



set lmargin 0
set rmargin 0
set tmargin 0
set bmargin 0

set view 57,45

set size 1,1.09
set term tikz standalone size 10cm, 10cm
set output outfile

set multiplot

splot infile using 1:(log($2)/log(2)):($3/100) with pm3d

set style line 5 lt rgb "#AA000000" lw 1
set pm3d interpolate 2,2
set pm3d depthorder hidden3d 1

splot infile using 1:(log($2)/log(2)):($3/100) with pm3d ls 5

unset multiplot
