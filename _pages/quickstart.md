---
title: Quickstart
weight: 1
---

In this section we’ll walk through building and starting an instance of Zipkin
and how to enable tracing on your service. 

## Docker

If you are familiar with Docker, the quickest way to get started quickly is to
use the [Docker Zipkin](https://github.com/openzipkin/docker-zipkin) project,
which (in addition to being able to build docker images) provides scripts and a
[`docker-compose.yml`](https://github.com/openzipkin/docker-zipkin/blob/master/docker-compose.yml)
for launching pre-built images, e.g.

{% highlight sh %}
git clone https://github.com/openzipkin/docker-zipkin
cd docker-zipkin
docker-compose up
{% endhighlight %}

## Running from Source

Zipkin can be run from source, if you are testing new features or cannot use
docker. These instructions are the first thing you see in the
[Zipkin](https://github.com/openzipkin/zipkin) GitHub repository.
