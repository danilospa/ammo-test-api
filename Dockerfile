FROM ruby:2.5.1

COPY . /app
WORKDIR /app

RUN bundle install -j4

expose 9292
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0"]
