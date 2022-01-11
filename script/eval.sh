#!/bin/bash

usage="Evaluate pfaedle parameters for an input GTFS feed. Write each evaluated parameter to its own own  output GTFS feed.
(C) 2021 University of Freiburg, Chair of Algorithms and Data Structures
Authors: Patrick Brosi <brosi@informatik.uni-freiburg.de>

Usage:

`basename $0` [-o/--output <outputdir (=out)>] [-f] [-m/--method <method>] [-c <pfaedle cfg>] -x <path/to/input/osm> <path/to/input/gtfs>"

# fail if any subcommand fails
set -Eeo pipefail

_output=out
_method=emission-progr-ours
_force=""

_lambda_trans=0.0083

# for debugging, display each command
#set -x

# check arguments
_f=""
_osm=""
_c=""

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
	  echo "$usage"
	  exit 0
      ;;
    -o|--output)
      _output="$2"
      shift
      shift
      ;;
    -f|--force)
      _force="1"
      shift
      ;;
    -m|--method)
      _method="$2"
      shift
      shift
      ;;
    -x|--osmfile)
      _osm="$2"
      shift
      shift
      ;;
    -c|--config)
      _c="$2"
      shift
      shift
      ;;
    -*|--*)
      echo "$1: option unknown"
      exit 1
      ;;
    *)
      _f="$1"
      shift
      ;;
  esac
done

if [ -z "$_f" ]
then
    echo "No GTFS feed specified, see --help."
    exit 1
fi

if [ -z "$_osm" ]
then
    echo "No OSM file specified, see --help."
    exit 1
fi

mkdir -p $_output

if [ $_method == "emission-progr-ours-raw" ]; then
	# assume a fixed transition lambda and test emission means here on a log scale, from 1 to 8192 meters
	for i in 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192
	do
		lambda_em=$(echo "scale=5; 1 / $i" | bc)
		for stddev in 0 10 20 30 40 50 60 70 80 90 100
		do
			out_dir=$_output/$stddev/$i
			mkdir -p $out_dir
			if test -f "$out_dir/shapes.txt"; then
				if [ -z "$_force" ]; then
					echo "  (Skipping existing $out_dir, use -f to overwrite)"
					continue
				fi
			fi
			echo " +++ Testing mean=$i with standard dev $stddev +++"
			/home/patrick/repos/pfaedle/build/pfaedle -x $_osm -D $_f -c $_c --gaussian-noise $stddev -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_move_penalty_fac:$lambda_em" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_non_station_penalty:9999" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_to_unmatched_time_penalty_fac:1"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_from_unmatched_time_penalty_fac:1" -o $out_dir
		done
	done
fi

if [ $_method == "emission-progr-ours-sm" ]; then
	# assume a fixed transition lambda and test emission means here on a log scale, from 1 to 8192 meters
	for i in 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192
	do
		lambda_em=$(echo "scale=5; 1 / $i" | bc)
		for stddev in 0 10 20 30 40 50 60 70 80 90 100
		do
			out_dir=$_output/$stddev/$i
			mkdir -p $out_dir
			if test -f "$out_dir/shapes.txt"; then
				if [ -z "$_force" ]; then
					echo "  (Skipping existing $out_dir, use -f to overwrite)"
					continue
				fi
			fi
			echo " +++ Testing mean=$i with standard dev $stddev +++"
			/home/patrick/repos/pfaedle/build/pfaedle -x $_osm -D $_f -c $_c --gaussian-noise $stddev -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_move_penalty_fac:$lambda_em" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_non_station_penalty:9999" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_to_unmatched_time_penalty_fac:1"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_from_unmatched_time_penalty_fac:1" -o $out_dir
		done
	done
fi

if [ $_method == "emission-progr-ours-sm-lm" ]; then
	# assume a fixed transition lambda and test emission means here on a log scale, from 1 to 8192 meters
	for i in 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192
	do
		lambda_em=$(echo "scale=5; 1 / $i" | bc)
		for stddev in 0 10 20 30 40 50 60 70 80 90 100
		do
			out_dir=$_output/$stddev/$i
			mkdir -p $out_dir
			if test -f "$out_dir/shapes.txt"; then
				if [ -z "$_force" ]; then
					echo "  (Skipping existing $out_dir, use -f to overwrite)"
					continue
				fi
			fi
			echo " +++ Testing mean=$i with standard dev $stddev +++"
			/home/patrick/repos/pfaedle/build/pfaedle -x $_osm -D $_f -c $_c --gaussian-noise $stddev -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_move_penalty_fac:$lambda_em" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_non_station_penalty:9999" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0" -o $out_dir
		done
	done
fi

if [ $_method == "transition-progr-dist-diff" ]; then
	# assume a fixed emission lambda and test transition means here on a log scale, from 1 to 8192 meters
	for i in 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192
	do
		lambda_t=$(echo "scale=5; 1 / $i" | bc)
		for stddev in 0 10 20 30 40 50 60 70 80 90 100
		do
			out_dir=$_output/$stddev/$i
			mkdir -p $out_dir
			if test -f "$out_dir/shapes.txt"; then
				if [ -z "$_force" ]; then
					echo "  (Skipping existing $out_dir, use -f to overwrite)"
					continue
				fi
			fi
			echo " +++ Testing mean=$i with standard dev $stddev +++"
			# lambda=1/4.07=0.2457 from original microsoft paper
			/home/patrick/repos/pfaedle/build/pfaedle -x $_osm -D $_f -c $_c --gaussian-noise $stddev -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_emission_method:norm" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_move_penalty_fac:0.2457" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_transition_penalty_fac:$lambda_t" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_transition_method:distdiff" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_non_station_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_to_unmatched_time_penalty_fac:1"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_from_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_use_stations:no" -o $out_dir
		done
	done
fi
