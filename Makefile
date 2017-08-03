.PHONY: doc build run test

VERSION ?= x.y
IMAGE_NAME = image
HELP_MD = ./help/help.md

doc:
	go-md2man -in=${HELP_MD} -out=./root/help.1

build: doc
	docker build --tag=$(IMAGE_NAME):$(VERSION) .

run: build
	docker run -d $(IMAGE_NAME):$(VERSION)

test: build
	cd ../tests; DOCKERFILE="../fedora/Dockerfile" MODULE=docker URL="docker=$(IMAGE_NAME):$(VERSION)" make all
	cd ../behave-tests; MODULE=docker URL="docker=$(IMAGE_NAME):$(VERSION)" make all
