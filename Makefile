PFAEDLE = /home/patrick/repos/pfaedle/build/pfaedle
CONFIG = eval.cfg

RESULTS_DIR := results
TABLES_DIR := tables

DATASETS = $(basename $(notdir $(wildcard gtfs/*.zip)))

#OSM_URL = http://download.geofabrik.de/europe-latest.osm.pbf
OSM_URL = http://download.geofabrik.de/europe/switzerland-latest.osm.pbf

TRIE_FASTHOPS_STAR := $(patsubst %, $(RESULTS_DIR)/%/trie-fasthops-star/stats.json, $(DATASETS))

.PRECIOUS: osm/%.osm

osmconvert:
	@echo `date +"[%F %T.%3N]"` "EVAL : Fetching osmconvert..."
	@curl http://m.m.i24.cc/osmconvert.c | cc -x c - -lz -O3 -o osmconvert

$(RESULTS_DIR)/%/trie-fasthops/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) --no-a-star -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/trie-fasthops-star/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/trie-cached/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) --no-a-star -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/trie-cached-star/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/fasthops/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) --no-a-star --no-trie --no-cache -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/fasthops-star/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) --no-trie --no-cache -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/cached/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) --no-fast-hops --no-a-star --no-trie -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/cached-star/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) --no-fast-hops --no-trie -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/baseline/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) --no-fast-hops --no-cache --no-a-star --no-trie -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

$(RESULTS_DIR)/%/baseline-star/stats.json: gtfs/ex/% osm/%.osm
	@mkdir -p $(dir $@)
	@echo `date +"[%F %T.%3N]"` "EVAL : Running performance evaluation for $@..."
	@$(PFAEDLE) --no-fast-hops --no-cache --no-trie -c $(CONFIG) -x osm/$*.osm -m all -D --stats -d $(dir $@) gtfs/ex/$*

gtfs/ex/%: gtfs/%.zip
	@mkdir -p $@
	@unzip -q $< -d $@

osm/europe-latest.osm.pbf:
	@mkdir -p osm
	@echo `date +"[%F %T.%3N]"` "EVAL : Downloading OSM data for Europe..."
	@curl --progress-bar $(OSM_URL) > $@

osm/europe-latest.osm: osm/europe-latest.osm.pbf
	@echo `date +"[%F %T.%3N]"` "EVAL : Converting OSM data from .pbf to .osm"
	@osmconvert --drop-version --drop-author $< > $@

osm/%.osm: osm/europe-latest.osm
	@echo `date +"[%F %T.%3N]"` "EVAL : Filtering OSM data for $*"
	@$(PFAEDLE) -x $< -i gtfs/ex/$* -c $(CONFIG) -m all -X $@


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

$(TABLES_DIR)/tbl-time.tex: script/table.py script/template.tex $(TRIE_FASTHOPS_STAR)
	@mkdir -p $(TABLES_DIR)
	@python3 script/table.py time $(patsubst %, $(RESULTS_DIR)/%, $(DATASETS)) > $@

$(TABLES_DIR)/tbl-time.pdf: $(TABLES_DIR)/tbl-time.tex
	@printf "[%s] Generating $@ ... \n" "$$(date -Is)"
	@cat script/template.tex > $(TABLES_DIR)/tmp
	@cat $^ >> $(TABLES_DIR)/tmp
	@echo "\\\end{document}" >> $(TABLES_DIR)/tmp
	@pdflatex -output-directory=$(TABLES_DIR) -jobname=tbl-time $(TABLES_DIR)/tmp > /dev/null
	@rm $(TABLES_DIR)/tmp

check:
	@echo "pfaedle version:" `$(PFAEDLE) --version`
	@echo "results dir:" $(RESULTS_DIR)
	@echo "datasets:" $(DATASETS)


clean:
	@rm -rf osm
	@rm -rf gtfs/ex
	@rm -rf $(RESULTS_DIR)
