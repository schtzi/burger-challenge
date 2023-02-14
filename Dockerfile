FROM ruby:3.0.1-slim

ENV TERM xterm
ENV WORKDIR /workspace

RUN mkdir -p ${WORKDIR} && gem install bundler -v 2.0.2

WORKDIR ${WORKDIR}

COPY Gemfile* ./
RUN bundle install

COPY ./ ./
