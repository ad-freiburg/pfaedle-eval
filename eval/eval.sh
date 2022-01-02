#!/bin/bash

# for i in 1 5 10 30 60 120 240 360 480 600 900 1200 1500 1800
# do
	# lambda=$(echo "scale=5; 1 / $i" | bc)
	# echo " +++ Testing mean="$i "+++"
    # ../build/pfaedle -x /home/patrick/osm_experiments/zurich.osm -D /home/patrick/gtfs/zurich/ -c ../pfaedle.cfg -m bus -P"[bus]routing_transition_penalty:$lambda" -o out/zurich-$i
# done

#for i in 1 50 100 250 500 750 1000 1500 2000 2500 3000 3500 5000 10000
for i in 250
do
	lambda=$(echo "scale=5; 1 / $i" | bc)
	echo " +++ Testing mean="$i "+++"
    ../build/pfaedle -x /home/patrick/osm_experiments/zurich.osm -D /home/patrick/gtfs/zurich/ -c ../pfaedle.cfg -m bus -P"[bus]routing_transition_penalty:$lambda" -P"[bus]routing_non_station_penalty:0" -P"[bus]routing_use_stations:no" -P"[bus]routing_transition_method:distdiff" -o out/zurich-$i
done
