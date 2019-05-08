FROM golang:1.12
CMD ["./main"]
EXPOSE 3000
RUN mkdir -p /go/src/github.com/openshift-evangelists/intro-katacoda
WORKDIR /go/src/github.com/openshift-evangelists/intro-katacoda
ADD . /go/src/github.com/openshift-evangelists/intro-katacoda
RUN go get && go build -a -installsuffix cgo -o main .
