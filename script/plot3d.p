set size 1,0.6

set key noautotitle

set zrange [0:100]
set xyplane at -5

set xtics offset -0.5,-0.5
set ytics offset 0.5,-0.5

set ytics ("2" 2, "8" 4, "32" 6, "128" 8,  "512" 10,  "2048" 12, "8192" 14)
set ylabel "$\\frac{1}{\\lambda_d}$"

set xlabel "$\\sigma$"

set zlabel "$AN_{90}$"

set pm3d interpolate 0,0
set dgrid3d 10,10,10

set view 57,45

set terminal postscript portrait enhanced color dashed lw 1 "DejaVuSans" 12
#set terminal latex
set output outfile.".ps"

set multiplot

splot infile using 1:(log($2)/log(2)):3 with pm3d

set style line 5 lt rgb "#AA000000" lw 1
set pm3d interpolate 2,2
set pm3d depthorder hidden3d 1

splot infile using 1:(log($2)/log(2)):3 with pm3d ls 5

unset multiplot

set terminal latex
set output outfile

set multiplot

splot infile using 1:(log($2)):3 with pm3d

set style line 5 lt rgb "#AA000000" lw 1
set pm3d interpolate 2,2
set pm3d depthorder hidden3d 1

splot infile using 1:(log($2)):3 with pm3d ls 5

unset multiplot
