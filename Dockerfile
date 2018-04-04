FROM golang:1.10

RUN go get software.sslmate.com/src/certspotter/cmd/certspotter
RUN mkdir -p /certspotter/

ADD run.sh /
ADD mailme.sh /

CMD ["/run.sh"]
