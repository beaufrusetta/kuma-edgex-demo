FROM envoyproxy/envoy-alpine:v1.12.2

COPY --from=kuma/base-image:0.4.0 /kuma-binaries/kuma-dp /usr/bin/kuma-dp
USER nobody:nobody

ENTRYPOINT ["kuma-dp"]
