FROM golang:1.13 AS builder

# Build dependency
RUN go get github.com/mreiferson/go-httpclient
RUN go get golang.org/x/net/idna 

# Prepare and build certspotter
RUN mkdir -p /certspotter
ADD certspotter /usr/local/go/src/software.sslmate.com/src/certspotter
RUN go install software.sslmate.com/src/certspotter/cmd/certspotter


FROM debian:stable-slim

# Additional package for mailing
RUN apt-get update && apt-get install -y \
    bash \
    mutt \
    && rm -rf /var/lib/apt/lists/*

COPY  --chown=65534:65534 --from=builder /usr/local/go/bin/certspotter /bin/

RUN mkdir /certspotter
RUN chown 65534:65534 /certspotter
WORKDIR /certspotter

USER 65534:65534

# Run script
ADD run.sh /

CMD ["/run.sh"]
