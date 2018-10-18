SHELL := /bin/bash

all: build run

run: build
	docker-compose run --rm web

build: .built .bundled

.built: Dockerfile
	docker-compose build
	touch .built

.bundled: Gemfile Gemfile.lock
	docker-compose run --rm web bundle install
	touch .bundled

logs:
	docker-compose logs

clean:
	docker-compose rm
	rm .built
	rm .bundled