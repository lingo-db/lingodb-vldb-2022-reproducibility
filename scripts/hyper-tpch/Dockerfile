FROM python:3
COPY scripts/hyper-tpch/generate-data.sh .
RUN mkdir /tpch-data-1
RUN mkdir /tpch-data-10

RUN bash generate-data.sh
COPY lingodb/resources/sql/tpch /tpch-queries
COPY scripts/hyper-tpch /hyper-script
RUN pip install tableauhyperapi==0.0.14946 jsonlines
