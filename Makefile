PFAEDLE = /home/patrick/repos/pfaedle/build/pfaedle
SHAPEVL = /home/patrick/repos/pfaedle/build/shapevl
CONFIG = eval.cfg

RESULTS_DIR := results
TABLES_DIR := tables
PLOTS_DIR := plots
GTFS_DIR := gtfs
OSM_DIR := osm

NOISE = 30

DATASETS = vitoria-gasteiz zurich wien sydney paris switzerland germany
GROUND_TRUTH_DATASETS = vitoria-gasteiz zurich wien sydney
#GROUND_TRUTH_DATASETS = vitoria-gasteiz

OSM_URL = http://download.geofabrik.de/europe-latest.osm.pbf
OSM_URL_AUSTRALIA = http://download.geofabrik.de/australia-latest.osm.pbf
#OSM_URL = http://download.geofabrik.de/europe/spain-latest.osm.pbf

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

.SECONDARY:

.SECONDEXPANSION:

osmconvert:
	@echo `date +"[%F %T.%3N]"` "EVAL : Fetching osmconvert..."
	@curl -L http://m.m.i24.cc/osmconvert.c | cc -x c - -lz -O3 -o osmconvert

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
	@# lambda_em=1/30=0.03 using the standard deviation of the noise we use
	@# lambda_t=1/28 ? from microsoft paper estimator, based on median distdiff in vitoria-gasteiz TODO: take average median over all test datasets
	@for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_emission_method:norm" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_move_penalty_fac:0.2457" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_transition_method:distdiff" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_transition_penalty_fac:0.0357" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_non_station_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_to_unmatched_time_penalty_fac:1"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_from_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_use_stations:no" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(RESULTS_DIR)/%/gsts/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)/gtfs
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (G-STS) for $@..."

	@# averaging because of gaussian noise
	@for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_move_penalty_fac:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_non_station_penalty:9999" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_to_unmatched_time_penalty_fac:1"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_from_unmatched_time_penalty_fac:1" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(RESULTS_DIR)/%/ours-raw/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)/gtfs
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (OURS-RAW) for $@..."

	@# averaging because of gaussian noise
	@for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_to_unmatched_time_penalty_fac:1"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_from_unmatched_time_penalty_fac:1" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(RESULTS_DIR)/%/ours-sm/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)/gtfs
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (OURS-SM) for $@..."

	@# averaging because of gaussian noise
	@for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_unmatched_time_penalty_fac:1" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_to_unmatched_time_penalty_fac:1"  -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_line_station_from_unmatched_time_penalty_fac:1" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(RESULTS_DIR)/%/ours-lm/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)/gtfs
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (OURS-RAW) for $@..."

	@# averaging because of gaussian noise
	@for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(RESULTS_DIR)/%/ours-sm-lm/stats.json: $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@mkdir -p $(dir $@)/gtfs
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (OURS-RAW) for $@..."

	@# averaging because of gaussian noise
	@for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do \
		echo `date +"[%F %T.%3N]"` "EVAL : Run # $$i" ; \
		$(PFAEDLE) -o $(dir $@)/gtfs/run-$$i -c $(CONFIG) -x $(OSM_DIR)/$*.osm -m all  --gaussian-noise $(NOISE) -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0" -D -d $(dir $@) $(GTFS_DIR)/ex/$* ; \
	done

	$(SHAPEVL) -g $< --json --avg $(dir $@)/gtfs/* > $@

$(GTFS_DIR)/ex/%: $(GTFS_DIR)/%.zip
	@mkdir -p $@
	@unzip -qo $< -d $@

$(OSM_DIR)/australia-latest.osm: osmconvert
	@mkdir -p $(OSM_DIR)
	@echo `date +"[%F %T.%3N]"` "EVAL : Downloading and converting OSM data for Australia..."
	@curl -L --progress-bar $(OSM_URL) | osmconvert --drop-version --drop-author > $@

$(OSM_DIR)/sydney.osm: $(OSM_DIR)/australia-latest.osm
	@echo `date +"[%F %T.%3N]"` "EVAL : Filtering OSM data for $*"
	@$(PFAEDLE) -x $< -i $(GTFS_DIR)/ex/$* -c $(CONFIG) -m all -X $@

$(OSM_DIR)/europe-latest.osm: osmconvert
	@mkdir -p $(OSM_DIR)
	@echo `date +"[%F %T.%3N]"` "EVAL : Downloading and converting OSM data for Europe..."
	@curl -L --progress-bar $(OSM_URL) | osmconvert --drop-version --drop-author > $@

$(OSM_DIR)/%.osm: $(OSM_DIR)/europe-latest.osm $(GTFS_DIR)/ex/%
	@echo `date +"[%F %T.%3N]"` "EVAL : Filtering OSM data for $*"
	@$(PFAEDLE) -x $< -i $(GTFS_DIR)/ex/$* -c $(CONFIG) -m all -X $@

$(GTFS_DIR)/zurich.zip:
	@mkdir -p $(GTFS_DIR)
	@curl -L --progress-bar https://data.stadt-zuerich.ch/dataset/vbz_fahrplandaten_gtfs/download/2022_google_transit.zip > $@

$(GTFS_DIR)/vitoria-gasteiz.zip:
	@#this is the last version with shape_dist_travelled
	@mkdir -p $(GTFS_DIR)
	@curl -L --progress-bar https://transitfeeds.com/p/tuvisa-euskotran/239/20211020/download > $@

$(GTFS_DIR)/wien.zip:
	@mkdir -p $(GTFS_DIR)
	@curl -L --progress-bar http://www.wienerlinien.at/ogd_realtime/doku/ogd/gtfs/gtfs.zip > $@

$(GTFS_DIR)/paris.zip:
	@mkdir -p $(GTFS_DIR)
	@curl -L --progress-bar https://data.iledefrance-mobilites.fr/explore/dataset/offre-horaires-tc-gtfs-idfm/files/a925e164271e4bca93433756d6a340d1/download/ > $@

$(GTFS_DIR)/switzerland.zip:
	@mkdir -p $(GTFS_DIR)
	@curl -L --progress-bar https://gtfs.geops.de/dl/gtfs_complete.zip > $@

$(GTFS_DIR)/germany.zip:
	@mkdir -p $(GTFS_DIR)
	@echo "*******************************************"
	@echo Please register and download latest GTFS version from https://www.opendata-oepnv.de/ht/de/organisation/delfi/startseite?tx_vrrkit_view%5Bdataset_name%5D=deutschlandweite-sollfahrplandaten-gtfs&tx_vrrkit_view%5Bdataset_formats%5D%5B0%5D=ZIP&tx_vrrkit_view%5Baction%5D=details&tx_vrrkit_view%5Bcontroller%5D=View to $@
	@echo "*******************************************"
	@exit 1

$(GTFS_DIR)/sydney.zip:
	@mkdir -p $(GTFS_DIR)
	@echo "*******************************************"
	@echo Please register and download latest GTFS version from https://opendata.transport.nsw.gov.au/dataset/timetables-complete-gtfs/resource/67974f14-01bf-47b7-bfa5-c7f2f8a950ca to $@
	@echo "*******************************************"
	@exit 1

## plots
$(PLOTS_DIR)/%/emission-progr-ours-raw: script/eval.sh $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@printf "[%s] Generating $@ ...\n" "$$(date -Is)"
	@./script/eval.sh -m emission-progr-ours-raw -x $(OSM_DIR)/$*.osm -c eval.cfg --output $@ $(GTFS_DIR)/ex/$*

$(PLOTS_DIR)/%/emission-progr-ours-sm: script/eval.sh $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@printf "[%s] Generating $@ ...\n" "$$(date -Is)"
	@./script/eval.sh -m emission-progr-ours-sm -x $(OSM_DIR)/$*.osm -c eval.cfg --output $@ $(GTFS_DIR)/ex/$*

$(PLOTS_DIR)/%/emission-progr-ours-sm-lm: script/eval.sh $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@printf "[%s] Generating $@ ...\n" "$$(date -Is)"
	@./script/eval.sh -m emission-progr-ours-sm-lm -x $(OSM_DIR)/$*.osm -c eval.cfg --output $@ $(GTFS_DIR)/ex/$*

$(PLOTS_DIR)/%/transition-progr-dist-diff: script/eval.sh $(GTFS_DIR)/ex/% $(OSM_DIR)/%.osm
	@printf "[%s] Generating $@ ...\n" "$$(date -Is)"
	@./script/eval.sh -m transition-progr-dist-diff -x $(OSM_DIR)/$*.osm -c eval.cfg --output $@ $(GTFS_DIR)/ex/$*

$(PLOTS_DIR)/%.tsv: $(PLOTS_DIR)/% $(GTFS_DIR)/ex/$$(firstword $$(subst /, ,%))
	@printf "[%s] Generating $@ ...\n" "$$(date -Is)"
	@$(SHAPEVL) -g $(GTFS_DIR)/ex/$(firstword $(subst /, ,$*)) -s $(PLOTS_DIR)/$*/*/* | cut -d'/' -f 9,10 --output-delimiter ' ' | sort -n -k2 -k1 | cut -d':' -f1,2 --output-delimiter ',' | cut -d',' -f1,4 --output-delimiter ' ' | tr -s ' ' '\t' > $@

$(PLOTS_DIR)/%/transition-progr-dist-diff.tex: $(PLOTS_DIR)/%/transition-progr-dist-diff.tsv script/plot3d.p
	@printf "[%s] Generating plot $@ ...\n" "$$(date -Is)"
	@gnuplot -e "infile='$<';outfile='$@';label='$$\\frac{1}{\\lambda_t}$$'" script/plot3d.p
	@pdflatex $@

$(PLOTS_DIR)/%.tex: $(PLOTS_DIR)/%.tsv script/plot3d.p
	@printf "[%s] Generating plot $@ ...\n" "$$(date -Is)"
	@gnuplot -e "infile='$<';outfile='$@';label='$$\\frac{1}{\\lambda_d}$$'" script/plot3d.p
	@pdflatex $@

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

$(TABLES_DIR)/tbl-main-res-max-frech.tex: script/table.py script/template.tex $(GSTS) $(OURS-RAW) $(OURS-SM) $(OURS-LM) $(OURS-SM-LM) $(DIST-DIFF)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py mainres-max-frech $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

plots: $(PLOTS-OURS-RAW) $(PLOTS-OURS-SM) $(PLOTS-OURS-SM-LM) $(PLOTS-OURS-SM-LM) $(PLOTS-DIST-DIFF)
tables: $(TABLES_DIR)/tbl-overview.pdf $(TABLES_DIR)/tbl-time.pdf $(TABLES_DIR)/tbl-main-res.pdf $(TABLES_DIR)/tbl-main-res-max-frech.tex

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
