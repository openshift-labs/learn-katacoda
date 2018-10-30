NAME=openshift-evangelists/intro-katacoda

dev:
	docker run -it -p 4000:3000 --rm -w /go/src/github.com/$(NAME) \
	  -v $(shell pwd):/go/src/github.com/$(NAME) \
	  golang:1.7

start:
	docker-compose -p openshift up -d
