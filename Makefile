# (C) 2021 University of Freiburg
# Chair of Algorithms and Data Structures
# Authors: Patrick Brosi (brosi@cs.uni-freiburg.de)

PFAEDLE = pfaedle
SHAPEVL = shapevl
CONFIG = eval.cfg

RESULTS_DIR := results
TABLES_DIR := tables
PLOTS_DIR := plots
GTFS_DIR := gtfs
OSM_DIR := osm

NOISE = 30

DATASETS = vitoria-gasteiz zurich seattle wien paris switzerland germany #sydney
GROUND_TRUTH_DATASETS = vitoria-gasteiz zurich seattle wien #sydney  // takes too long to evaluate

OSM_URL = http://download.geofabrik.de/europe-latest.osm.pbf
OSM_URL_AUSTRALIA = http://download.geofabrik.de/australia-oceania/australia-latest.osm.pbf
OSM_URL_WASHINGTON = http://download.geofabrik.de/north-america/us/washington-latest.osm.pbf

# time comp
TRIE_FASTHOPS_STAR := $(patsubst %, $(RESULTS_DIR)/%/trie-fasthops-star/stats.json, $(DATASETS))
TRIE_FASTHOPS := $(patsubst %, $(RESULTS_DIR)/%/trie-fasthops/stats.json, $(DATASETS))
TRIE_CACHED_STAR := $(patsubst %, $(RESULTS_DIR)/%/trie-cached-star/stats.json, $(DATASETS))
TRIE_CACHED := $(patsubst %, $(RESULTS_DIR)/%/trie-cached/stats.json, $(DATASETS))
FASTHOPS_STAR := $(patsubst %, $(RESULTS_DIR)/%/fasthops-star/stats.json, $(DATASETS))
FASTHOPS := $(patsubst %, $(RESULTS_DIR)/%/fasthops/stats.json, $(DATASETS))
CACHED_STAR := $(patsubst %, $(RESULTS_DIR)/%/cached-star/stats.json, $(DATASETS))
CACHED := $(patsubst %, $(RESULTS_DIR)/%/cached/stats.json, $(DATASETS))
BASELINE_STAR := $(patsubst %, $(RESULTS_DIR)/%/baseline-star/stats.json, $(DATASETS))
BASELINE := $(patsubst %, $(RESULTS_DIR)/%/baseline/stats.json, $(DATASETS))

# quality comp
GSTS := $(patsubst %, $(RESULTS_DIR)/%/gsts/stats.json, $(GROUND_TRUTH_DATASETS))
#DIST-RATIO := $(patsubst %, $(RESULTS_DIR)/%/dist-ratio/stats.json, $(GROUND_TRUTH_DATASETS))
DIST-DIFF := $(patsubst %, $(RESULTS_DIR)/%/dist-diff/stats.json, $(GROUND_TRUTH_DATASETS))
OURS-RAW := $(patsubst %, $(RESULTS_DIR)/%/ours-raw/stats.json, $(GROUND_TRUTH_DATASETS))
OURS-SM := $(patsubst %, $(RESULTS_DIR)/%/ours-sm/stats.json, $(GROUND_TRUTH_DATASETS))
OURS-LM := $(patsubst %, $(RESULTS_DIR)/%/ours-lm/stats.json, $(GROUND_TRUTH_DATASETS))
OURS-SM-LM := $(patsubst %, $(RESULTS_DIR)/%/ours-sm-lm/stats.json, $(GROUND_TRUTH_DATASETS))

PLOTS-OURS-RAW := $(patsubst %, $(PLOTS_DIR)/%/emission-progr-ours-raw.tex, $(GROUND_TRUTH_DATASETS))
PLOTS-OURS-SM := $(patsubst %, $(PLOTS_DIR)/%/emission-progr-ours-sm.tex, $(GROUND_TRUTH_DATASETS))
PLOTS-OURS-SM-LM := $(patsubst %, $(PLOTS_DIR)/%/emission-progr-ours-sm-lm.tex, $(GROUND_TRUTH_DATASETS))
PLOTS-OURS-SM-LM := $(patsubst %, $(PLOTS_DIR)/%/emission-progr-ours-sm-lm.tex, $(GROUND_TRUTH_DATASETS))
PLOTS-DIST-DIFF := $(patsubst %, $(PLOTS_DIR)/%/transition-progr-dist-diff, $(GROUND_TRUTH_DATASETS))

PLOTS-ALL := $(PLOTS_DIR)/emission-progr-ours-raw-all.tex  $(PLOTS_DIR)/emission-progr-ours-sm-all.tex $(PLOTS_DIR)/emission-progr-ours-sm-lm-all.tex $(PLOTS_DIR)/emission-progr-ours-sm-lm-all.tex $(PLOTS_DIR)/transition-progr-dist-diff-all.tex

.SECONDARY:

.SECONDEXPANSION:

$(RESULTS_DIR)/%/trie-fasthops/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-a-star -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all -D --stats -d $(dir $@) $(GTFS_DIR)/ex/$*

$(RESULTS_DIR)/%/trie-fasthops-star/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all -D --stats -d $(dir $@) $(GTFS_DIR)/ex/$*

$(RESULTS_DIR)/%/trie-cached/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm

	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-a-star --no-fast-hops -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all -D --stats -d $(dir $@) $(GTFS_DIR)/ex/$*

$(RESULTS_DIR)/%/trie-cached-star/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-fast-hops -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all -D --stats -d $(dir $@) $(GTFS_DIR)/ex/$*

$(RESULTS_DIR)/%/fasthops/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-a-star --no-trie -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all -D --stats -d $(dir $@) $(GTFS_DIR)/ex/$*

$(RESULTS_DIR)/%/fasthops-star/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-trie -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all -D --stats -d $(dir $@) $(GTFS_DIR)/ex/$*

$(RESULTS_DIR)/%/cached/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-fast-hops --no-a-star --no-trie -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all -D --stats -d $(dir $@) $(GTFS_DIR)/ex/$*

$(RESULTS_DIR)/%/cached-star/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-fast-hops --no-trie -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all -D --stats -d $(dir $@) $(GTFS_DIR)/ex/$*

$(RESULTS_DIR)/%/baseline/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-fast-hops --no-hop-cache --no-a-star --no-trie -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all -D --stats -d $(dir $@) $(GTFS_DIR)/ex/$*

$(RESULTS_DIR)/%/baseline-star/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-fast-hops --no-hop-cache --no-trie -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all -D --stats -d $(dir $@) $(GTFS_DIR)/ex/$*

$(RESULTS_DIR)/%/dist-diff/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)/gtfs
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (DIST-DIFF) for $@..."

	@# averaging because of gaussian noise
	@# lambda_em=1/4.07=0.2457 from original microsoft paper
	@# lambda_t~1/17.0387 from microsoft paper estimator, based on average median distdiff over testing datasets:
	@# 18.7555 vitoria
	@# 18.966 zurich
	@# 1.009 seattle
	@# 7.77 wien
	@# 12.551 sydney
	@for i in 1 2 3 4 5 6 7 8 9 10; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_emission_method:norm" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_move_penalty_fac:0.2457" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_transition_method:distdiff" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_transition_penalty_fac:0.0586901" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_non_station_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_to_unmatched_time_penalty_fac:1"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_from_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_use_stations:no" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(RESULTS_DIR)/%/gsts/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)/gtfs
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (G-STS) for $@..."

	@# averaging because of gaussian noise
	@for i in 1 2 3 4 5 6 7 8 9 10; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_move_penalty_fac:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_non_station_penalty:9999" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_to_unmatched_time_penalty_fac:1"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_from_unmatched_time_penalty_fac:1" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(RESULTS_DIR)/%/ours-raw/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)/gtfs
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (OURS-RAW) for $@..."

	@# averaging because of gaussian noise
	@for i in 1 2 3 4 5 6 7 8 9 10; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_to_unmatched_time_penalty_fac:1"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_from_unmatched_time_penalty_fac:1" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(RESULTS_DIR)/%/ours-sm/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)/gtfs
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (OURS-SM) for $@..."

	@# averaging because of gaussian noise
	@for i in 1 2 3 4 5 6 7 8 9 10; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_to_unmatched_time_penalty_fac:1"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_from_unmatched_time_penalty_fac:1" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(RESULTS_DIR)/%/ours-lm/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)/gtfs
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (OURS-RAW) for $@..."

	@# averaging because of gaussian noise
	@for i in 1 2 3 4 5 6 7 8 9 10; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(RESULTS_DIR)/%/ours-sm-lm/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)/gtfs
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (OURS-RAW) for $@..."

	@# averaging because of gaussian noise
	@for i in 1 2 3 4 5 6 7 8 9 10; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(GTFS_DIR)/ex/%: $(GTFS_DIR)/%.zip
	@mkdir -p $@
	@unzip -qo $< -d $@

$(OSM_DIR)/filterrules:
	@mkdir -p $(OSM_DIR)
	@$(PFAEDLE) -c $(CONFIG) --osmfilter > $@

$(OSM_DIR)/australia-latest.osm: $(OSM_DIR)/filterrules
	@mkdir -p $(OSM_DIR)
	@echo `date +"[%F %T.%3N]"` "EVAL : Downloading and converting OSM data for Australia..."
	@curl -sL $(OSM_URL_AUSTRALIA) | osmconvert - --out-o5m --drop-version --drop-author > $@.o5m
	@osmfilter --parameter-file=$< $@.o5m -o=$@

$(OSM_DIR)/washington-latest.osm: $(OSM_DIR)/filterrules
	@mkdir -p $(OSM_DIR)
	@echo `date +"[%F %T.%3N]"` "EVAL : Downloading and converting OSM data for US-Washington..."
	@curl -sL $(OSM_URL_WASHINGTON) | osmconvert - --out-o5m --drop-version --drop-author > $@.o5m
	@osmfilter --parameter-file=$< $@.o5m -o=$@

$(OSM_DIR)/europe-latest.osm: $(OSM_DIR)/filterrules
	@mkdir -p $(OSM_DIR)
	@echo `date +"[%F %T.%3N]"` "EVAL : Downloading and converting OSM data for Europe..."
	@curl -sL $(OSM_URL) | osmconvert - --out-o5m --drop-version --drop-author > $@.o5m
	@osmfilter --parameter-file=$< $@.o5m -o=$@

$(OSM_DIR)/sydney.osm: $(OSM_DIR)/australia-latest.osm $(GTFS_DIR)/ex/sydney
	@echo `date +"[%F %T.%3N]"` "EVAL : Filtering OSM data for sydney"
	@$(PFAEDLE) -x $< -i $(GTFS_DIR)/ex/sydney -c $(CONFIG) -m all -X $@

$(OSM_DIR)/seattle.osm: $(OSM_DIR)/washington-latest.osm $(GTFS_DIR)/ex/seattle
	@echo `date +"[%F %T.%3N]"` "EVAL : Filtering OSM data for seattle"
	@$(PFAEDLE) -x $< -i $(GTFS_DIR)/ex/seattle -c $(CONFIG) -m all -X $@

$(OSM_DIR)/%.osm: $(OSM_DIR)/europe-latest.osm $(GTFS_DIR)/ex/%
	@echo `date +"[%F %T.%3N]"` "EVAL : Filtering OSM data for $*"
	@$(PFAEDLE) -x $< -i $(GTFS_DIR)/ex/$* -c $(CONFIG) -m all -X $@

$(GTFS_DIR)/zurich.zip:
	@mkdir -p $(GTFS_DIR)
	@curl -L --progress-bar https://data.stadt-zuerich.ch/dataset/vbz_fahrplandaten_gtfs/download/2022_google_transit.zip > $@

$(GTFS_DIR)/vitoria-gasteiz.zip:
	@#this is the last version with shape_dist_travelled, which we need for the evaluation
	@mkdir -p $(GTFS_DIR)
	@curl -L --progress-bar https://transitfeeds.com/p/tuvisa-euskotran/239/20211020/download > $@

$(GTFS_DIR)/wien.zip:
	@mkdir -p $(GTFS_DIR)
	@curl -L --progress-bar http://www.wienerlinien.at/ogd_realtime/doku/ogd/gtfs/gtfs.zip > $@

$(GTFS_DIR)/seattle.zip:
	@mkdir -p $(GTFS_DIR)
	@curl -L --progress-bar https://transitfeeds.com/p/king-county-metro/73/latest/download > $@

$(GTFS_DIR)/paris.zip:
	@mkdir -p $(GTFS_DIR)
	@curl -L --progress-bar https://data.iledefrance-mobilites.fr/explore/dataset/offre-horaires-tc-gtfs-idfm/files/a925e164271e4bca93433756d6a340d1/download/ > $@

$(GTFS_DIR)/switzerland.zip:
	@mkdir -p $(GTFS_DIR)
	@curl -L --progress-bar https://gtfs.geops.de/dl/gtfs_complete.zip > $@

$(GTFS_DIR)/germany.zip:
	@mkdir -p $(GTFS_DIR)
	@echo "*******************************************"
	@echo "Please register and download latest GTFS version from https://www.opendata-oepnv.de/ht/de/organisation/delfi/startseite?tx_vrrkit_view%5Bdataset_name%5D=deutschlandweite-sollfahrplandaten-gtfs&tx_vrrkit_view%5Bdataset_formats%5D%5B0%5D=ZIP&tx_vrrkit_view%5Baction%5D=details&tx_vrrkit_view%5Bcontroller%5D=View to $@"
	@echo "*******************************************"
	@exit 1

$(GTFS_DIR)/sydney.zip:
	@mkdir -p $(GTFS_DIR)
	@echo "*******************************************"
	@echo "Please register and download latest GTFS version from https://opendata.transport.nsw.gov.au/dataset/timetables-complete-gtfs/resource/67974f14-01bf-47b7-bfa5-c7f2f8a950ca to $@"
	@echo "*******************************************"
	@exit 1

## plots
$(PLOTS_DIR)/%/run-1 $(PLOTS_DIR)/%/run-2 $(PLOTS_DIR)/%/run-3 $(PLOTS_DIR)/%/run-4 $(PLOTS_DIR)/%/run-5 $(PLOTS_DIR)/%/run-6 $(PLOTS_DIR)/%/run-7 $(PLOTS_DIR)/%/run-8 $(PLOTS_DIR)/%/run-9 $(PLOTS_DIR)/%/run-10 : script/eval.sh $(GTFS_DIR)/ex/$$(subst /, ,$$(dir %)) $(OSM_DIR)/$$(subst /,,$$(dir %)).osm
	@printf "[%s] Generating $@ ...\n" "$$(date -Is)"
	@./script/eval.sh -m $(basename $(notdir $*)) -x $(OSM_DIR)/$(subst /,,$(dir $*)).osm -c $(CONFIG) --output $(PLOTS_DIR)/$* $(GTFS_DIR)/ex/$(dir $*)

$(PLOTS_DIR)/%-all.tsv: $(patsubst %, $(PLOTS_DIR)/%/$$*-avg.tsv, $(GROUND_TRUTH_DATASETS))
	@# take the average of the input file columns
	@cat $< | cut -f1,2 > tmp1
	@paste -d ' ' $^ | tr '\t' ' ' | sed -r 's/[0-9]+ [0-9]+ ([0-9]+\.?[0-9]*)/\1/g;s/ /+/g;s/.*/scale=4;(&)\/$(words $^)/g' | bc > tmp2
	@paste -d ' ' tmp1 tmp2 > $@

$(PLOTS_DIR)/%-avg.tsv: $(PLOTS_DIR)/%/run-1-res.tsv  $(PLOTS_DIR)/%/run-2-res.tsv $(PLOTS_DIR)/%/run-3-res.tsv $(PLOTS_DIR)/%/run-4-res.tsv $(PLOTS_DIR)/%/run-5-res.tsv $(PLOTS_DIR)/%/run-6-res.tsv $(PLOTS_DIR)/%/run-7-res.tsv $(PLOTS_DIR)/%/run-8-res.tsv $(PLOTS_DIR)/%/run-9-res.tsv $(PLOTS_DIR)/%/run-10-res.tsv
	@printf "[%s] Generating $@ ...\n" "$$(date -Is)"
	@# take the average of the input file columns
	@cat $< | cut -f1,2 > tmp1
	@paste -d ' ' $^ | tr '\t' ' ' | sed -r 's/[0-9]+ [0-9]+ ([0-9]+\.?[0-9]*)/\1/g;s/ /+/g;s/.*/scale=4;(&)\/$(words $^)/g' | bc > tmp2
	@paste -d ' ' tmp1 tmp2 > $@

$(PLOTS_DIR)/%-res.tsv: $(PLOTS_DIR)/%
	@printf "[%s] Generating $@ ...\n" "$$(date -Is)"
	$(SHAPEVL) -g $(GTFS_DIR)/ex/$(firstword $(subst /, ,$*)) -s $(PLOTS_DIR)/$*/*/* | rev | cut -d'/' -f 1,2 --output-delimiter ' ' | rev | sort -n -k2 -k1 | cut -d':' -f1,2 --output-delimiter ',' | cut -d',' -f1,4 --output-delimiter ' ' | tr -s ' ' '\t' > $@

$(PLOTS_DIR)/%/transition-progr-dist-diff-avg.tex: $(PLOTS_DIR)/%/transition-progr-dist-diff-avg.tsv script/plot3d.p
	@printf "[%s] Generating plot $@ ...\n" "$$(date -Is)"
	@gnuplot -e "infile='$<';outfile='$@';label='$$\\frac{1}{\\lambda_t}$$'" script/plot3d.p
	@pdflatex -output-directory=$(PLOTS_DIR)/$* $@

$(PLOTS_DIR)/transition-progr-dist-diff-all.tex: $(PLOTS_DIR)/transition-progr-dist-diff-all.tsv script/plot3d.p
	@printf "[%s] Generating plot $@ ...\n" "$$(date -Is)"
	@gnuplot -e "infile='$<';outfile='$@';label='$$\\frac{1}{\\lambda_t}$$'" script/plot3d.p
	@pdflatex -output-directory=$(PLOTS_DIR) $@

$(PLOTS_DIR)/%.tex: $(PLOTS_DIR)/%.tsv script/plot3d.p
	@printf "[%s] Generating plot $@ ...\n" "$$(date -Is)"
	@gnuplot -e "infile='$<';outfile='$@';label='$$\\frac{1}{\\lambda_d}$$'" script/plot3d.p
	pdflatex -output-directory=$(dir $(PLOTS_DIR)/$*) $@

## tables
$(TABLES_DIR)/%.pdf: $(TABLES_DIR)/%.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=$* $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

$(TABLES_DIR)/tbl-overview.tex: script/table.py script/template.tex $(TRIE_FASTHOPS_STAR)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py overview $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-time.tex: script/table.py script/template.tex $(TRIE_FASTHOPS_STAR) $(TRIE_FASTHOPS) $(TRIE_CACHED_STAR) $(TRIE_CACHED) $(FASTHOPS_STAR) $(FASTHOPS) $(CACHED_STAR) $(CACHED) $(BASELINE_STAR) $(BASELINE)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py time $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-main-res.tex: script/table.py script/template.tex $(GSTS) $(OURS-RAW) $(OURS-SM) $(OURS-LM) $(OURS-SM-LM) $(DIST-DIFF)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py mainres $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-main-res-avg-frech.tex: script/table.py script/template.tex $(GSTS) $(OURS-RAW) $(OURS-SM) $(OURS-LM) $(OURS-SM-LM) $(DIST-DIFF)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py mainres-avg-frech $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

plots: $(PLOTS-OURS-RAW) $(PLOTS-OURS-SM) $(PLOTS-OURS-SM-LM) $(PLOTS-OURS-SM-LM) $(PLOTS-DIST-DIFF) $(PLOTS-ALL)
tables: $(TABLES_DIR)/tbl-overview.pdf $(TABLES_DIR)/tbl-time.pdf $(TABLES_DIR)/tbl-main-res.pdf $(TABLES_DIR)/tbl-main-res-avg-frech.tex

check:
	@echo "pfaedle version:" `$(PFAEDLE) --version`
	@echo "results dir:" $(RESULTS_DIR)
	@echo "tables dir:" $(TABLES_DIR)
	@echo "plots dir:" $(PLOTS_DIR)
	@echo "osm dir:" $(OSM_DIR)
	@echo "datasets:" $(DATASETS)

help:
	@cat README.md

clean:
	@rm -rf osm
	@rm -rf $(GTFS_DIR)
	@rm -rf $(RESULTS_DIR)
	@rm -rf $(TABLES_DIR)
	@rm -rf $(PLOTS_DIR)
	@rm -rf $(OSM_DIR)
