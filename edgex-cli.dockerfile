FROM golang:latest

WORKDIR /go
RUN git clone https://github.com/edgexfoundry-holding/edgex-cli && cd edgex-cli && make install

FROM alpine:3.10

RUN mkdir /edgex
WORKDIR /edgex
COPY --from=0 /go/bin/edgex-cli /edgex/edgex-cli

CMD ["/bin/sh"]
