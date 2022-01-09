PFAEDLE = /home/patrick/repos/pfaedle/build/pfaedle
SHAPEVL = /home/patrick/repos/pfaedle/build/shapevl
CONFIG = eval.cfg

RESULTS_DIR := results
TABLES_DIR := tables
PLOTS_DIR := plots

DATASETS = vitoria-gasteiz zurich vrs sydney paris switzerland germany

#OSM_URL = http://download.geofabrik.de/europe-latest.osm.pbf
OSM_URL = http://download.geofabrik.de/europe/spain-latest.osm.pbf

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
GSTS := $(patsubst %, $(RESULTS_DIR)/%/gsts/stats.json, $(DATASETS))

.PRECIOUS: osm/%.osm
.PRECIOUS: plots/%.tsv

.SECONDEXPANSION:

osmconvert:
	@echo `date +"[%F %T.%3N]"` "EVAL : Fetching osmconvert..."
	@curl -L http://m.m.i24.cc/osmconvert.c | cc -x c - -lz -O3 -o osmconvert

$(RESULTS_DIR)/%/trie-fasthops/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-a-star -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/trie-fasthops-star/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/trie-cached/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-a-star --no-fast-hops -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/trie-cached-star/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-fast-hops -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/fasthops/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-a-star --no-trie -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/fasthops-star/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-trie -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/cached/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-fast-hops --no-a-star --no-trie -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/cached-star/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-fast-hops --no-trie -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/baseline/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-fast-hops --no-hop-cache --no-a-star --no-trie -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/baseline-star/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -o $(dir $@)/gtfs --no-fast-hops --no-hop-cache --no-trie -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/gsts/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running quality evaluation (G-STS) for $@..."

	$(PFAEDLE) -o $(dir $@)/gtfs -c $(CONFIG) -x osm/$*.osm -m all  --gaussian-noise 30 -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_move_penalty_fac:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_non_station_penalty:9999" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_station_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_platform_unmatched_penalty:0" -P"[tram, bus, coach, subway, rail, gondola, funicular, ferry]routing_use_stations:yes" -D -d $(dir $@) gtfs/ex/$*

	$(SHAPEVL) -g $< --json $(dir $@)/gtfs > $@

gtfs/ex/%: gtfs/%.zip
	@mkdir -p $@
	@unzip -qo $< -d $@

osm/australia-latest.osm.pbf:
	@mkdir -p osm
	@echo `date +"[%F %T.%3N]"` "EVAL : Downloading OSM data for Australia..."
	@curl -L --progress-bar $(OSM_URL) > $@

osm/australia-latest.osm: osm/australia-latest.osm.pbf
	@echo `date +"[%F %T.%3N]"` "EVAL : Converting OSM data from .pbf to .osm"
	@osmconvert --drop-version --drop-author $< > $@

osm/sydney.osm: osm/australia-latest.osm
	@echo `date +"[%F %T.%3N]"` "EVAL : Filtering OSM data for $*"
	@$(PFAEDLE) -x $< -i gtfs/ex/$* -c $(CONFIG) -m all -X $@

osm/europe-latest.osm.pbf:
	@mkdir -p osm
	@echo `date +"[%F %T.%3N]"` "EVAL : Downloading OSM data for Europe..."
	@curl -L --progress-bar $(OSM_URL) > $@

osm/europe-latest.osm: osm/europe-latest.osm.pbf
	@echo `date +"[%F %T.%3N]"` "EVAL : Converting OSM data from .pbf to .osm"
	@osmconvert --drop-version --drop-author $< > $@

osm/%.osm: osm/europe-latest.osm
	@echo `date +"[%F %T.%3N]"` "EVAL : Filtering OSM data for $*"
	@$(PFAEDLE) -x $< -i gtfs/ex/$* -c $(CONFIG) -m all -X $@

gtfs/zurich.zip:
	@curl -L --progress-bar https://data.stadt-zuerich.ch/dataset/vbz_fahrplandaten_gtfs/download/2022_google_transit.zip > $@

gtfs/vitoria-gasteiz.zip:
	@curl -L --progress-bar http://www.vitoria-gasteiz.org/we001/http/vgTransit/google_transit.zip > $@

gtfs/vrs.zip:
	@curl -L --progress-bar https://download.vrsinfo.de/gtfs/google_transit.zip > $@

gtfs/paris.zip:
	@curl -L --progress-bar https://data.iledefrance-mobilites.fr/explore/dataset/offre-horaires-tc-gtfs-idfm/files/a925e164271e4bca93433756d6a340d1/download/ > $@

gtfs/switzerland.zip:
	@curl -L --progress-bar https://gtfs.geops.de/dl/gtfs_complete.zip > $@

gtfs/germany.zip:
	@echo *******************************************
	@echo Please register and download latest GTFS version from https://www.opendata-oepnv.de/ht/de/organisation/delfi/startseite?tx_vrrkit_view%5Bdataset_name%5D=deutschlandweite-sollfahrplandaten-gtfs&tx_vrrkit_view%5Bdataset_formats%5D%5B0%5D=ZIP&tx_vrrkit_view%5Baction%5D=details&tx_vrrkit_view%5Bcontroller%5D=View to $@
	@echo *******************************************

gtfs/sydney.zip:
	@echo *******************************************
	@echo Please register and download latest GTFS version from https://opendata.transport.nsw.gov.au/dataset/timetables-complete-gtfs/resource/67974f14-01bf-47b7-bfa5-c7f2f8a950ca to $@
	@echo *******************************************

## plots
$(PLOTS_DIR)/%/emission-progr-ours: script/eval.sh gtfs/ex/% osm/%.osm
	@printf "[%s] Generating $@ ..." "$$(date -Is)"
	@./script/eval.sh -m emission-progr-ours -x osm/$*.osm -c eval.cfg --output $@ gtfs/ex/$*

$(PLOTS_DIR)/%.tsv: $(PLOTS_DIR)/% gtfs/ex/$$(firstword $$(subst /, ,%))
	@printf "[%s] Generating $@ ..." "$$(date -Is)"
	$(SHAPEVL) -g gtfs/ex/$(firstword $(subst /, ,$*)) -s $</*/* | cut -d'/' -f 9,10 --output-delimiter ' ' | sort -n -k2 -k1 | cut -d':' -f1,2 --output-delimiter ',' | cut -d',' -f1,4 --output-delimiter ' ' | tr -s ' ' '\t' > $@

$(PLOTS_DIR)/%.tex: $(PLOTS_DIR)/%.tsv script/plot3d.p
	@printf "[%s] Generating plot $@ ..." "$$(date -Is)"
	@gnuplot -e "infile='$<';outfile='$@'" script/plot3d.p

## tables
$(TABLES_DIR)/tbl-overview.tex: script/table.py script/template.tex $(TRIE_FASTHOPS_STAR)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py overview $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-overview.pdf: $(TABLES_DIR)/tbl-overview.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-overview $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

$(TABLES_DIR)/tbl-time.tex: script/table.py script/template.tex $(TRIE_FASTHOPS_STAR) $(TRIE_FASTHOPS) $(TRIE_CACHED_STAR) $(TRIE_CACHED) $(FASTHOPS_STAR) $(FASTHOPS) $(CACHED_STAR) $(CACHED) $(BASELINE_STAR) $(BASELINE)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py time $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-time.pdf: $(TABLES_DIR)/tbl-time.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-time $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

$(TABLES_DIR)/tbl-main-res.tex: script/table.py script/template.tex
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py mainres $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-main-res.pdf: $(TABLES_DIR)/tbl-main-res.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-main-res $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

check:
	@echo "pfaedle version:" `$(PFAEDLE) --version`
	@echo "results dir:" $(RESULTS_DIR)
	@echo "datasets:" $(DATASETS)


clean:
	@rm -rf osm
	@rm -rf gtfs/ex
	@rm -rf $(RESULTS_DIR)
