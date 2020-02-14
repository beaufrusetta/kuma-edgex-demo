# using Envoy's base to inherit the Envoy binary
FROM envoyproxy/envoy-alpine:v1.12.2

ADD binaries/bin/kuma-dp /usr/bin

RUN mkdir /kuma
COPY templates/LICENSE /kuma
COPY templates/NOTICE /kuma
COPY templates/README /kuma

USER nobody:nobody

ENTRYPOINT ["kuma-dp"]
