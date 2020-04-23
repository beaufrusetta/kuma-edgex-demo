FROM alpine:3.10

COPY --from=kuma/base-image:0.4.0 /kuma-binaries/kuma-cp /usr/bin/kuma-cp
USER nobody:nobody

ENTRYPOINT ["kuma-cp"]