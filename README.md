# Ammo Test API

This project is the API for the AMMO tech test. It provides a single endpoint to query for the products.

## Dependencies

- Ruby 2.5.1
- Elasticsearch
- Redis

## How to contribute

First of all, make sure you have the correct Ruby version installed. Then, install bundler and project dependencies.
```bash
$ gem install bundler
$ bundler install -j4
```

Copy project configuration file and change it as needed:
```bash
$ cp env.example .env
```

Before starting the server, you should execute both Elasticsearch and Redis. The easiest way is to run through docker:
```bash
$ docker run -p 9200:9200 elasticsearch
$ docker run -p 6379:6379 redis
```

You can also map the volumes so the data won't be lost when container stops.
```bash
$ docker run -p 9200:9200 -v $(pwd)/elasticsearch/data:/usr/share/elasticsearch/data elasticsearch
$ docker run -p 6379:6379 -v $(pwd)/redis/data:/data redis
```

Import data to both Elasticsearch and Redis:
```bash
$ ruby import_data.rb
```

To start the server, run:
```bash
$ bundle exec puma
```

The server should be up and listening on port 9292.

To run the tests:
```bash
$ bundle exec rspec
```

To run the linter:
```bash
$ bundle exec rubocop
```

## How to run

You can follow the steps above to run using Ruby from your machine. Or you can use Docker to run the main application too. The following command will start it and both Elasticsearch and Redis:
```bash
$ docker-compose up
```

Afterwards, import data to Elasticsearch and Redis running a command on the application container. First, get the container ID, then execute the command.
```bash
$ docker ps | grep 9292
$ docker exec -it <container_id> ruby import_data.rb
```
