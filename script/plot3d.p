set key noautotitle

set zrange [0:100]
set xyplane at -10

set xtics offset -0.5,-0.5
set ytics offset 0.5,-0.5
set ztics offset 1.5,0

set ytics ("2" 2, "8" 4, "32" 6, "128" 8,  "512" 10,  "2048" 12, "8192" 14)

set ylabel label

set xlabel "$\\sigma$"

set zlabel "$AN_{90}$"

set pm3d interpolate 1,1
set dgrid3d 10,10,10

set lmargin 0
set rmargin 0
set tmargin 0
set bmargin 0

set view 57,45

set size 1,1.09
set term tikz standalone size 10cm, 10cm
#set term tikz size 10cm, 10cm
set output outfile

set multiplot

splot infile using 1:(log($2)):3 with pm3d

set style line 5 lt rgb "#AA000000" lw 1
set pm3d interpolate 2,2
set pm3d depthorder hidden3d 1

splot infile using 1:(log($2)):3 with pm3d ls 5

unset multiplot
