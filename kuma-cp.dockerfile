FROM alpine:3.10

COPY --from=kuma/base-image:0.3.2 /kuma-binaries/kuma-cp /usr/bin/kuma-cp
RUN mkdir -p /etc/kuma
ADD config/kuma-cp.defaults.yaml /etc/kuma
USER nobody:nobody

ENTRYPOINT ["kuma-cp"]
