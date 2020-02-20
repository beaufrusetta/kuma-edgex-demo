FROM alpine:3.10

WORKDIR /kuma-binaries
RUN wget https://kong.bintray.com/kuma/kuma-0.3.2-ubuntu-amd64.tar.gz && \
    tar -C /kuma-binaries -xzf kuma-0.3.2-ubuntu-amd64.tar.gz ./bin/kuma-cp ./bin/kuma-dp ./bin/kumactl && \
    mv bin/kuma* . && rm -rf bin/ && rm kuma-0.3.2-ubuntu-amd64.tar.gz