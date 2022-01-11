FROM ubuntu:20.04
ARG GRB_VERSION=9.1.2
ARG GRB_SHORT_VERSION=9.1

WORKDIR /opt

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --no-install-recommends -y\
       ca-certificates  \
       curl \
       make \
       cmake \
	   gnuplot \
	   texlive-base \
	   texlive-science \
	   texlive-latex-extra \
	   texlive-latex-base \
	   g++ \
       git \
    && update-ca-certificates

ENV PATH $PATH:/pfaedle/build

ADD pfaedle /pfaedle

RUN cd /pfaedle && rm -rf build && mkdir build && cd build && cmake .. && make -j20 pfaedle && make -j20 shapevl

RUN mkdir -p /output

COPY Makefile /
COPY README.md /
ADD script /script

RUN make help

WORKDIR /

ENTRYPOINT ["make", "RESULTS_DIR=/output/results", "TABLES_DIR=/output/tables", "PLOTS_DIR=/output/plots", "GTFS_DIR=/output/gtfs", "OSM_DIR=/output/osm"]
