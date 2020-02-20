FROM alpine:3.10

RUN apk add --no-cache curl
COPY --from=kuma/base-image:0.3.2 /kuma-binaries/kumactl /usr/bin/kumactl
RUN addgroup -S -g 6789 kumactl \
 && adduser -S -D -G kumactl -u 6789 kumactl

USER kumactl
WORKDIR /home/kumactl

CMD ["/bin/sh"]
