FROM golang:1.10


# Build dependency
RUN go get github.com/mreiferson/go-httpclient
RUN go get golang.org/x/net/idna 

# Prepare and build certspotter
RUN mkdir -p /certspotter
ADD certspotter /usr/local/go/src/software.sslmate.com/src/certspotter
RUN go install software.sslmate.com/src/certspotter/cmd/certspotter

# Run script
ADD run.sh /

# Additional package for mailing
RUN apt-get update
RUN apt-get install -y mutt 
RUN apt-get clean 

WORKDIR /certspotter

CMD ["/run.sh"]
