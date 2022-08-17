FROM ubuntu AS baseimg
COPY duckdb /duckdb
WORKDIR /duckdb
RUN DEBIAN_FRONTEND="noninteractive" apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install make build-essential
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install cmake
RUN BUILD_BENCHMARK=1 BUILD_TPCH=1 make -j$(nproc)
