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

The [Docker Zipkin](https://github.com/openzipkin/zipkin/tree/master/docker) project is able to build docker images, provide scripts and a [`docker-compose.yml`](https://github.com/openzipkin/docker-zipkin/blob/master/docker-compose.yml)
for launching pre-built images. The quickest start is to run the latest image directly:

~~~ bash
docker run -d -p 9411:9411 openzipkin/zipkin
~~~

## Java

If you have Java 17 or higher installed, the quickest way to get started is to fetch the [latest release](https://search.maven.org/remote_content?g=io.zipkin&a=zipkin-server&v=LATEST&c=exec) as a self-contained executable jar:

~~~ bash
curl -sSL https://zipkin.io/quickstart.sh | bash -s
java -jar zipkin.jar
~~~

## Homebrew

If you have [Homebrew](https://brew.sh/) installed, the quickest way to get started is to install
the [zipkin formula](https://formulae.brew.sh/formula/zipkin).

~~~ bash
brew install zipkin
# to run in foreground
zipkin
# to run in background
brew services start zipkin
~~~

## Running from Source

Zipkin can be run from source if you are developing new features. To achieve this, you'll need to
get [Zipkin's source](https://github.com/openzipkin/zipkin) and build it.

~~~ bash
# get the latest source
git clone https://github.com/openzipkin/zipkin
cd zipkin
# Build the server and also make its dependencies
./mvnw -T1C -q --batch-mode -DskipTests --also-make -pl zipkin-server clean package
# Run the server
java -jar ./zipkin-server/target/zipkin-server-*exec.jar
# or Run the slim server
java -jar ./zipkin-server/target/zipkin-server-*slim.jar
~~~

Stop by and socialize with us on [gitter](https://gitter.im/openzipkin/zipkin), if you end up making something interesting!
