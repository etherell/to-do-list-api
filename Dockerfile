FROM ruby:2.7.2
RUN apt-get update -qq \
    && apt-get install -y nodejs postgresql-client cmake
ENV DB_USER="postgres"
ENV DB_PASSWORD="postgres"
ADD . /app
WORKDIR /app
RUN bundle install
EXPOSE 3000
