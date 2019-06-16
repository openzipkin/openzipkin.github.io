---
title: Quickstart
weight: 1
---


In this section we’ll walk through building and starting an instance of Zipkin
for checking out Zipkin locally. There are three options: using Java, Docker or running from source.

If you are familiar with Docker, this is the preferred method to start. If you are unfamiliar with Docker, try running via Java or from source.

Regardless of how you start Zipkin, browse to http://your_host:9411 to find traces!
{: .message}

## Docker

The [Docker Zipkin](https://github.com/openzipkin/docker-zipkin) project is able to build docker images, provide scripts and a [`docker-compose.yml`](https://github.com/openzipkin/docker-zipkin/blob/master/docker-compose.yml)
for launching pre-built images. The quickest start is to run the latest image directly:

~~~ bash
docker run -d -p 9411:9411 openzipkin/zipkin
~~~

## Java

If you have Java 8 or higher installed, the quickest way to get started is to fetch the [latest release](https://search.maven.org/remote_content?g=io.zipkin.java&a=zipkin-server&v=LATEST&c=exec) as a self-contained executable jar:

~~~ bash
curl -sSL https://zipkin.io/quickstart.sh | bash -s
java -jar zipkin.jar
~~~

## Running from Source

Zipkin can be run from source if you are developing new features. To achieve this, you'll need to get [Zipkin's source](https://github.com/openzipkin/zipkin) and build it.

~~~ bash
# get the latest source
git clone https://github.com/openzipkin/zipkin
cd zipkin
# Build the server and also make its dependencies
./mvnw -DskipTests --also-make -pl zipkin-server clean install
# Run the server
java -jar ./zipkin-server/target/zipkin-server-*exec.jar
~~~

Stop by and socialize with us on [gitter](https://gitter.im/openzipkin/zipkin), if you end up making something interesting!
