---
title: Quickstart
weight: 1
---

In this section we’ll walk through building and starting an instance of Zipkin
for checking out Zipkin locally. There are two options: using Docker and running from source. If you are familiar with Docker, this is the preferred method to start. If you are unfamiliar with Docker, try running from source.
{: .message}

## Docker

The [Docker Zipkin](https://github.com/openzipkin/docker-zipkin) project is able to build docker images, provide scripts and a
[`docker-compose.yml`](https://github.com/openzipkin/docker-zipkin/blob/master/docker-compose.yml)
for launching pre-built images. All you need to do is enter the following commands:

~~~ bash
git clone https://github.com/openzipkin/docker-zipkin
cd docker-zipkin
docker-compose up
~~~

## Running from Source

Zipkin can be run from source if you are testing new features or chose not to use
Docker. The [`bin`](https://github.com/openzipkin/zipkin/tree/master/bin)
directory of the source repository provides scripts to minimize the amount of
copy-pasting.

1. Get the zipkin source and change to its directory.

   ~~~ bash
   git clone https://github.com/openzipkin/zipkin
   cd zipkin
   ~~~

1. In separate terminal windows or tabs, start
   * The query server: `./bin/query`
   * The collector server: `./bin/collector`
   * The web server: `./bin/web`

1. Create dummy traces: `./bin/tracegen`

1. Open the UI at [http://localhost:8080](http://localhost:8080) and look at the traces!
