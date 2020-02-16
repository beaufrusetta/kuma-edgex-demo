# using Envoy's base to inherit the Envoy binary
FROM envoyproxy/envoy-alpine:v1.12.2

RUN wget https://kong.bintray.com/kuma/kuma-0.3.2-ubuntu-amd64.tar.gz && \
    tar -C /usr -xzf kuma-0.3.2-ubuntu-amd64.tar.gz ./bin/kuma-dp && \
    rm kuma-0.3.2-ubuntu-amd64.tar.gz

RUN mkdir /kuma
COPY templates/LICENSE /kuma
COPY templates/NOTICE /kuma
COPY templates/README /kuma

USER nobody:nobody

ENTRYPOINT ["kuma-dp"]
