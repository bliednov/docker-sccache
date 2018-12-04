FROM rust as builder

WORKDIR /usr/src/sccache

RUN apt-get update \
 && apt-get install -y libssl-dev --no-install-recommends

RUN cargo install --features="dist-server" sccache --git https://github.com/mozilla/sccache.git --rev 8f295c09cfdd4cff4f4a0c6f0e057979eeb8842d --path .

FROM debian:stretch-slim

RUN apt-get update \
 && apt-get install -y libssl1.1 --no-install-recommends

COPY --from=builder /usr/local/cargo/bin/sccache-dist /usr/local/bin/sccache-dist

STOPSIGNAL SIGINT

ENTRYPOINT ["/usr/local/bin/sccache-dist"]

