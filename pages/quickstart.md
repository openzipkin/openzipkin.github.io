---
title: Quickstart
weight: 1
---

In this section we’ll walk through building and starting an instance of Zipkin
for checking out Zipkin locally.

## Docker

If you are familiar with Docker, the quickest way to get started quickly is to
use the [Docker Zipkin](https://github.com/openzipkin/docker-zipkin) project,
which (in addition to being able to build docker images) provides scripts and a
[`docker-compose.yml`](https://github.com/openzipkin/docker-zipkin/blob/master/docker-compose.yml)
for launching pre-built images, e.g.

~~~ bash
git clone https://github.com/openzipkin/docker-zipkin
cd docker-zipkin
docker-compose up
~~~

## Running from Source

Zipkin can be run from source, if you are testing new features or cannot use
Docker. The [`bin`](https://github.com/openzipkin/zipkin/tree/master/bin)
directory of the source repository provides scripts to minimize the amount of
copy-pasting.

1. Get the zipkin source and change to its directory
 
   ~~~ bash
   git clone https://github.com/openzipkin/zipkin
   cd zipkin
   ~~~
   
1. In separate terminal windows / tabs start
   1. The query server: `./bin/query`
   1. The collector server: `./bin/collector`
   1. The web server: `./bin/web`
  
1. Create dummy traces: `./bin/tracegen`
   
1. Open the UI at [http://localhost:8080](http://localhost:8080) and look at the traces!
