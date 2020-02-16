FROM alpine:3.10

RUN wget https://kong.bintray.com/kuma/kuma-0.3.2-ubuntu-amd64.tar.gz && \
    tar -C /usr -xzf kuma-0.3.2-ubuntu-amd64.tar.gz ./bin/kuma-cp && \
    rm kuma-0.3.2-ubuntu-amd64.tar.gz

RUN mkdir -p /etc/kuma
ADD config/kuma-cp.defaults.yaml /etc/kuma

USER nobody:nobody

ENTRYPOINT ["kuma-cp"]
