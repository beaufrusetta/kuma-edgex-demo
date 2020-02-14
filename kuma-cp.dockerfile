FROM alpine:3.10

ADD binaries/bin/kuma-cp /usr/bin

RUN mkdir -p /etc/kuma
ADD config/kuma-cp.defaults.yaml /etc/kuma

RUN mkdir /kuma
COPY templates/LICENSE /kuma
COPY templates/NOTICE /kuma
COPY templates/README /kuma

USER nobody:nobody

ENTRYPOINT ["kuma-cp"]
