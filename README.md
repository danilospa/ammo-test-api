# Ammo Test API

This project is the API for the AMMO tech test. It provides a single endpoint to query for the products.

## Dependencies

- Ruby 2.5.1

## How to run

First of all, make sure you have the correct Ruby version installed. Then, install bundler and project dependencies.
```bash
$ gem install bundler
$ bundler install -j4
```

To start the server, run:
```bash
$ bundle exec rackup
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
