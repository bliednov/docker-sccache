FROM rust as builder

WORKDIR /usr/src/sccache

RUN apt-get update \
 && apt-get install -y libssl-dev --no-install-recommends

RUN cargo install --features="dist-server,all" sccache --git https://github.com/mozilla/sccache.git --rev 490240b593a1a104cde4fb5caa763c1bd1769a1f

FROM debian:bullseye-slim

RUN apt-get update \
 && apt-get install -y libssl1.1 --no-install-recommends \
 && apt-get install bubblewrap -y

COPY --from=builder /usr/local/cargo/bin/sccache-dist /usr/local/bin/sccache-dist

STOPSIGNAL SIGINT

ENV SCCACHE_NO_DAEMON=1
ENV RUST_LOG=trace

ENTRYPOINT ["/usr/local/bin/sccache-dist"]
