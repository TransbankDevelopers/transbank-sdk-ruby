FROM ruby:2.2-jessie
RUN apt-get update && apt-get install
RUN gem install bundler -v 1.17.3
RUN mkdir -p /sdk
WORKDIR /sdk
COPY . /sdk
