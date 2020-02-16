FROM alpine:3.10

RUN apk add --no-cache curl

RUN wget https://kong.bintray.com/kuma/kuma-0.3.2-ubuntu-amd64.tar.gz && \
    tar -C /usr -xzf kuma-0.3.2-ubuntu-amd64.tar.gz ./bin/kumactl && \
    rm kuma-0.3.2-ubuntu-amd64.tar.gz

RUN addgroup -S -g 6789 kumactl \
 && adduser -S -D -G kumactl -u 6789 kumactl

USER kumactl
WORKDIR /home/kumactl

CMD ["/bin/sh"]
