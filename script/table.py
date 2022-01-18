#!/usr/bin/python3

# (C) 2021 University of Freiburg
# Chair of Algorithms and Data Structures
# Authors: Patrick Brosi (brosi@cs.uni-freiburg.de)

import json
from statistics import median
import sys
import os
import math

DATASET_LABELS = {
    "zurich": "Zurich",
    "vitoria-gasteiz": "Vit.-Gast.",
    "seattle": "Seattle",
    "sydney": "Sydney",
    "wien": "Vienna",
    "paris": "Paris",
    "switzerland": "Switzerland",
    "germany": "Germany",
}

DATASET_LABELS_SHORT = {
    "zurich": "ZH",
    "vitoria-gasteiz": "VG",
    "sydney": "SY",
    "wien": "V",
    "seattle": "SE",
    "sydney": "SY",
    "paris": "P",
    "switzerland": "CH",
    "germany": "DE",
}


def read_result(path):
    ret = {}
    try:
        with open(path) as f:
            full = json.load(f)
            ret = full["statistics"]
    except BaseException:
        pass

    return ret


def read_results(path):
    # all methods are hardcoded here
    ret = {}

    for root, subdirs, files in os.walk(path):
        for filename in files:
            _, ext = os.path.splitext(filename)
            if ext != ".json":
                continue
            file_path = os.path.join(root, filename)
            rel_path = os.path.relpath(file_path, path)
            comps = rel_path.split(os.sep)

            if not comps[0] in ret:
                ret[comps[0]] = {}

            result = read_result(file_path)
            if result is not None:
                ret[comps[0]] = result

    return ret


def scinot(num):
    if num is None:
        return "---"
    magni = math.floor(math.log(num, 10))
    ret = "\\Hsci{"
    ret += "%.0f" % (num / (math.pow(10, magni)))
    ret += "}{"
    ret += str(magni)
    ret += "}"

    return ret


def get(res, a, b=None):
    if a not in res:
        return None
    if b not in res[a]:
        return None
    return res[a][b]


def format_int(n):
    if n is None:
        return "---"

    if n < 1000:
        return "%d" % n

    if n < 1000000:
        return "%.1f\\Hk" % (n / 1000)

    if n < 1000000000:
        return "%.1f\\HM" % (n / 1000000)

    return "%.1f\\HB" % (n / 1000000000)


def format_float(n):
    if n is None:
        return "---"
    return "%.1f" % n

def format_perc(n):
    if n is None:
        return "---"
    return "%.1f\\%%" % n


def format_secs(s):
    return format_msecs(s * 1000)


def format_msecs(ms):
    if ms is None:
        return "---"

    if ms < 0.1:
        return "$<1$\\Hms"

    if ms < 1:
        return "%.1f\\Hms" % ms

    if ms < 100:
        return "%.0f\\Hms" % ms

    if ms < 1000 * 60:
        return "%.1f\\Hs" % (ms / 1000.0)

    if ms < 1000 * 60 * 60:
        return "%.1f\\Hm" % (ms / (60 * 1000.0))

    return "%.1f\\Hh" % (ms / (60 * 60 * 1000.0))

def bold_if(s, t):
    if not t:
        return s
    return "\\textbf{" + s + "}"

def tbl_overview(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Dimensions of our map-matching evaluation datasets. Under \emph{stations} we give the total number of stations contained in the GTFS feed. Under \emph{avg dist} we give the average distance in meters between consecutive trip stops (the average sample point distance). Under \emph{trips} we give the total number of contained trips. Under \emph{unique trips} we give the number of trips that only differ in their attributes (MOT, line name) and their station course, but not in the time offset at the first station or the service date. Under \emph{tries} we give the number of trip tries (unique trips sharing common station course prefixes). Under \emph{shapes} we denote whether ground truth shape data was available. The total number of edges over all transportation network graphs for all MOTs is given under $|E|$.\label{TBL:pfaedle:datasets}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\\setlength\\tabcolsep{3pt}\n"

    ret += "  \\begin{tabular*}{\\textwidth}{@{\\extracolsep{\\fill}} l r r r r r c r} \\toprule\n       & stations & avg dist & trips & unique trips & tries & shapes & $|E|$\\\\\\midrule\n"

    sort = []
    for dataset_id in results:
        sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["trie-fasthops-star"]["gtfs_num_trips"])

    for dataset_id in sort:
        r = results[dataset_id]
        ret += "    %s & %s & %s & %s & %s & %s & %s & %s\\\\\n" % (DATASET_LABELS[dataset_id] + " (" + DATASET_LABELS_SHORT[dataset_id] + ")",
                                                                    format_int(get(r, "trie-fasthops-star", "gtfs_num_stations")),
                                                                    format_float(get(r, "trie-fasthops-star", "gtfs_avg_hop_dist")),
                                                                    format_int(get(r, "trie-fasthops-star", "gtfs_num_trips")),
                                                                    format_int(get(r, "trie-fasthops-star", "num_trie_leafs")),
                                                                    format_int(get(r, "trie-fasthops-star", "num_tries")),
                                                                    "TODO",
                                                                    format_int(get(r, "trie-fasthops-star", "num_edges_tot")))

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret

def tbl_main_res(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\\setlength\\tabcolsep{5pt}\n"

    ret += "\\begin{tabular*}{\\textwidth}{@{\extracolsep{\\fill}} l r r r r r r r}\n"
    #  ret += "    && & \\multicolumn{5}{c}{\\footnotesize HMM} \\\\\n"
    #  ret += "  \\cline{4-8} \\\\[-2ex] \\toprule\n"
    ret += " && \\footnotesize{G-STS} & \\footnotesize{DIST-DIFF} & \\footnotesize{OURS} & \\footnotesize{OURS+SM} & \\footnotesize{OURS+LM} & \\footnotesize{OURS+SM+LM}\\\\\\toprule\n"

    sort = []
    for dataset_id in results:
        if "gsts" in results[dataset_id]:
            sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["gsts"]["num-trips"])

    for dataset_id in sort:
        r = results[dataset_id]
        m = sorted([((get(r, m, "an-10") if get(r, m, "an-10") is not None else 0), m) for m in r], reverse=True)

        ret += "%s && %s & %s & %s & %s & %s & %s\\\\\n" % (DATASET_LABELS_SHORT[dataset_id],
                            bold_if(format_perc(get(r, "gsts", "an-10")), "gsts" == m[0][1]),
                            bold_if(format_perc(get(r, "dist-diff", "an-10")), "dist-diff" == m[0][1]),
                            bold_if(format_perc(get(r, "ours-raw", "an-10")), "ours-raw" == m[0][1]),
                            bold_if(format_perc(get(r, "ours-sm", "an-10")), "ours-sm" == m[0][1]),
                            bold_if(format_perc(get(r, "ours-lm", "an-10")), "ours-lm" == m[0][1]),
                            bold_if(format_perc(get(r, "ours-sm-lm", "an-10")), "ours-sm-lm" == m[0][1]),
                            )

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret

def tbl_main_res_avg_frech(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Averaged Frechet dist in meters, averaged over all trips}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\\setlength\\tabcolsep{5pt}\n"

    ret += "\\begin{tabular*}{\\textwidth}{@{\extracolsep{\\fill}} l r r r r r r r}\n"
    ret += " && \\footnotesize{G-STS} & \\footnotesize{DIST-DIFF} & \\footnotesize{OURS} & \\footnotesize{OURS+SM} & \\footnotesize{OURS+LM} & \\footnotesize{OURS+SM+LM}\\\\\\toprule\n"

    sort = []
    for dataset_id in results:
        if "gsts" in results[dataset_id]:
            sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["gsts"]["num-trips"])

    for dataset_id in sort:
        r = results[dataset_id]
        m = sorted([((get(r, m, "avg-fr") if get(r, m, "avg-fr") is not None else 999), m) for m in r])

        ret += "%s && %s & %s & %s & %s & %s & %s\\\\\n" % (DATASET_LABELS_SHORT[dataset_id],
                            bold_if(format_float(get(r, "gsts", "avg-fr")), m[0][1] == "gsts"),
                            bold_if(format_float(get(r, "dist-diff", "avg-fr")), m[0][1] == "dist-diff"),
                            bold_if(format_float(get(r, "ours-raw", "avg-fr")), m[0][1] == "ours-raw"),
                            bold_if(format_float(get(r, "ours-sm", "avg-fr")), m[0][1] == "ours-sm"),
                            bold_if(format_float(get(r, "ours-lm", "avg-fr")), m[0][1] == "ours-lm"),
                            bold_if(format_float(get(r, "ours-sm-lm", "avg-fr")), m[0][1] == "ours-sm-lm"),
                            )

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret

def tbl_main_res_time(results):
    ret = "\\begin{table}\n"
    ret += "  \\centering\n"
    ret += "  \\caption[]{Running times of our baseline approach B (clustered equivalent trips and $n$ 1-to-$m$ Dijkstra runs between layers), CA (with shortest path cost caching), SDL (single Dijkstra run between two layers), CA+TR (shortest path cost caching on a trip trie), and SDL+TR (single Dijkstra run between layers on a trip trie). The unstarred version use a standard Dijkstra implementation, the starred versions use the $A^*$ heuristic described in Section~\TODO{}. Best times are printed bold. \\label{TBL:pfaedle:res-time}}\n"
    ret += "    {\\renewcommand{\\baselinestretch}{1.13}\\normalsize\\setlength\\tabcolsep{5pt}\n"

    ret += "\\begin{tabular*}{\\textwidth}{@{\extracolsep{\\fill}} l r r r r r r r r r r r r}\n"
    ret += " && \\footnotesize{B} & \\footnotesize{CA} & \\footnotesize{SDL} & \\footnotesize{CA+TR} & \\footnotesize{SDL+TR} & \\footnotesize{B*} & \\footnotesize{CA*} & \\footnotesize{SDL*} & \\footnotesize{CA+TR*} & \\footnotesize{SDL+TR*} \\\\\\toprule\n"

    sort = []
    for dataset_id in results:
        if dataset_id not in {"baseline", "cached", "fasthops", "trie-cached", "trie-fasthops", "baseline-star", "cached-star", "fasthops-star", "trie-cached-star", "trie-fasthops-star"}:
            continue
        sort.append(dataset_id)

    sort = sorted(
        sort, key=lambda d: results[d]["trie-fasthops-star"]["gtfs_num_trips"])

    for dataset_id in sort:
        r = results[dataset_id]
        m = sorted([(get(r, m, "time_solve"), m) for m in r])
        ret += "%s && %s & %s & %s & %s & %s & %s & %s & %s & %s & %s &\\\\\n" % (DATASET_LABELS_SHORT[dataset_id],
                            bold_if(format_msecs(get(r, "baseline", "time_solve")), m[0][1] == "baseline"),
                            bold_if(format_msecs(get(r, "cached", "time_solve")), m[0][1] == "cached"),
                            bold_if(format_msecs(get(r, "fasthops", "time_solve")), m[0][1] == "fasthops"),
                            bold_if(format_msecs(get(r, "trie-cached", "time_solve")), m[0][1] == "trie-cached"),
                            bold_if(format_msecs(get(r, "trie-fasthops", "time_solve")), m[0][1] == "trie-fasthops"),
                            bold_if(format_msecs(get(r, "baseline-star", "time_solve")), m[0][1] == "baseline-star"),
                            bold_if(format_msecs(get(r, "cached-star", "time_solve")), m[0][1] == "cached-star"),
                            bold_if(format_msecs(get(r, "fasthops-star", "time_solve")), m[0][1] == "fasthops-star"),
                            bold_if(format_msecs(get(r, "trie-cached-star", "time_solve")), m[0][1] == "trie-cached-star"),
                            bold_if(format_msecs(get(r, "trie-fasthops-star", "time_solve")), m[0][1] == "trie-fasthops-star"),
                            )

    ret += "\\bottomrule"
    ret += "\\end{tabular*}}\n"
    ret += "\\end{table}\n"

    return ret


def main():
    if len(sys.argv) < 3:
        print("Generates .tex files for result tables\n")
        print("  Usage: " + sys.argv[0] + " <table> <dataset results paths>")
        print(
            "\n  where <table> is one of {TODO}")
        sys.exit(1)

    results = {}

    for d in sys.argv[2:]:
        results[os.path.basename(os.path.normpath(d))] = read_results(d)

    if sys.argv[1] == "overview":
        print(tbl_overview(results))

    if sys.argv[1] == "time":
        print(tbl_main_res_time(results))

    if sys.argv[1] == "mainres":
        print(tbl_main_res(results))

    if sys.argv[1] == "mainres-avg-frech":
        print(tbl_main_res_avg_frech(results))


if __name__ == "__main__":
    main()
