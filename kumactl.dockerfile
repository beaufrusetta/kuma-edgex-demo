FROM alpine:3.10

RUN apk add --no-cache curl

ADD ./binaries/bin/kumactl /usr/bin

RUN mkdir /kuma
COPY ./templates/LICENSE /kuma
COPY ./templates/NOTICE /kuma
COPY ./templates/README /kuma

RUN addgroup -S -g 6789 kumactl \
 && adduser -S -D -G kumactl -u 6789 kumactl

USER kumactl
WORKDIR /home/kumactl

CMD ["/bin/sh"]
