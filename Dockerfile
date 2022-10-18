FROM ruby:3.1.2

# Environment variables
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /app

# Install Systen packages
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends apt-utils

RUN apt-get install -y vim

COPY Gemfile Gemfile.lock ./

COPY . .

EXPOSE 3000
