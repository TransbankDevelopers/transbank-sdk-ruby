FROM ruby:3.0.5-slim-bullseye
RUN apt-get update && apt-get install
RUN mkdir -p /sdk
WORKDIR /sdk
COPY . /sdk