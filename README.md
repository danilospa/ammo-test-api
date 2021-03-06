# Ammo Test API

This project is the API for the AMMO tech test. It provides a single endpoint to query for the products.

## Dependencies

- Ruby 2.5.1
- Elasticsearch 6.2.4
- Redis 4.0.9

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
$ docker run -it -p 9200:9200 docker.elastic.co/elasticsearch/elasticsearch:6.2.4
$ docker run -p 6379:6379 redis:4.0.9
```

Note: if you face problems related to virtual memory too low, execute the command `sudo sysctl -w vm.max_map_count=262144`. Reference [here](https://github.com/docker-library/elasticsearch/issues/111).

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

## How to deploy

Production deploy is made automatically by [CircleCI](https://circleci.com/gh/danilospa/ammo-test-api) when merging into master branch.  
After the continuous integration builds and pushes the docker image to [Dockerhub](https://hub.docker.com/r/danilospa/ammo-test-api/), [Watchtower](https://github.com/v2tec/watchtower) verifies for updates on the image, pull it and start again.  
Watchtower and ammo-test-api currently runs on the same AWS EC2, along with a Nginx with reverse proxy to the application.

