---
title: Server extensions and choices
weight: 4
---

## Server extensions
Zipkin server bundles extension for span collection and storage. By default spans can be collected over http, Kafka or RabbitMQ transports and stored in-memory or in MySQL, Cassandra or Elasticsearch.

The following modules add storage or transport extensions to the default server build.
Please refer to their individual documentation for setup and configuration guides.

### OpenZipkin supported

The following extensions are supported by the OpenZipkin team and are hosted at
the [OpenZipkin GitHub](https://github.com/openzipkin/) group. You can reach out to
the team on [Zipkin Gitter](https://gitter.im/openzipkin/zipkin/) chat.

| Type | Module | Related product | Other notes |
|:-----|:--------|:----------------|:------------|{% for extension in site.data.openzipkin_extensions %}
| {{ extension.type }} | {{ extension.module }} | {{extension.product}} | {{ extension.notes }} |{% endfor %}
{: .wide-table}

### Community supported

| Type | Module | Related product | Other notes |
|:-----|:--------|:----------------|:------------|{% for extension in site.data.community_extensions %}
| {{ extension.type }} | {{ extension.module }} | {{extension.product}} | {{ extension.notes }} |{% endfor %}
{: .wide-table}


## Alternative servers

The OpenZipkin team publish apis, data formats, and shared libraries that allow alternate backends to process the
same data sent to the default Zipkin server.

### Community supported

Listed below are alternative backends that accept Zipkin format. Some use the same code as Zipkin on the same endpoints while others are on alternative endpoints or partially support features. In any case, the following aim to allow existing zipkin clients to use backends the OpenZipkin team does not support. Hence, direct questions to their respective communities.
    
 - [Apache SkyWalking](https://github.com/apache/incubator-skywalking)
   - When [zipkin-receiver](https://github.com/apache/incubator-skywalking/blob/master/docs/en/setup/backend/backend-receivers.md) is enabled, Skywalking exposes the same HTTP POST endpoints Zipkin does
     - http port 9411 accepts `/api/v1/spans` (thrift, json) and `/api/v2/spans` (json, proto) POST requests.
     - this extension uses the same encoding library and same endpoints as Zipkin does.
 - [jaeger](https://github.com/jaegertracing/jaeger)
   - When `COLLECTOR_ZIPKIN_HTTP_PORT=9411` is set, Jaeger exposes a partial implementation of Zipkin's HTTP POST endpoints
     - http port 9411 accepts `/api/v1/spans` (thrift, json) and `/api/v2/spans` (json, but not proto) POST requests.
   - When `SPAN_STORAGE_TYPE=kafka` and `zipkin-thrift`, Jaeger reads Zipkin v1 thrift encoded span messages from a Kafka topic.
     - Note: The above is a [deprecated practice](https://github.com/openzipkin/zipkin/tree/master/zipkin-collector/kafka#legacy-encoding) in Zipkin. Most instrumentation bundle multiple spans per message in v2 format.
 - [Pitchfork](https://github.com/HotelsDotCom/pitchfork)
   - Pitchfork exposes the same HTTP POST endpoints Zipkin does
     - http port 9411 accepts `/api/v1/spans` (thrift, json) and `/api/v2/spans` (json, proto) POST requests.

Did we miss a server extension or alternative? Please open a pull-request to
[openzipkin.github.io](https://github.com/openzipkin/openzipkin.github.io).

