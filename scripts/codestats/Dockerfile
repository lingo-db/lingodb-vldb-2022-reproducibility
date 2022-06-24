FROM ubuntu:impish

RUN apt-get update && apt-get install -y cloc

COPY scripts/codestats/cloc.defs /cloc.defs
WORKDIR /data
VOLUME "/data"
VOLUME "/filters"
ENTRYPOINT ["/usr/bin/cloc"]
CMD ["--force-lang-def=/cloc.defs"]