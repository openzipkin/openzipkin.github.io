---
title: Existing server integrations
weight: 4
---

### OpenZipkin server integrations
Zipkin server bundles integration for span collection and storage. By default spans can be collected over http, Kafka or RabbitMQ transports and stored in-memory or in MySQL, Cassandra or Elasticsearch. Zipkin is extensible with external modules which allow alternate transport or storage options. Here is a list of ones maintained by the core team.

| Type | Module | Related product | Other notes |
|:-----|:--------|:----------------|:------------|{% for integration in site.data.openzipkin_transport_integrations %}
| {{ integration.type }} | {{ integration.module }} | {{integration.product}} | {{ integration.notes }} |{% endfor %}
{: .wide-table}


### Community server integrations
   
| Type | Module | Related product | Other notes |
|:-----|:--------|:----------------|:------------|{% for integration in site.data.community_transport_integrations %}
| {{ integration.type }} | {{ integration.module }} | {{integration.product}} | {{ integration.notes }} |{% endfor %}
{: .wide-table}


### Community server Alternatives
Listed below are alternative servers that accept Zipkin format. Some use the same code as Zipkin on the same endpoints while others are on alternative endpoints or partially support features. In any case, these integrations aim to allow existing zipkin clients to use alternative backends the OpenZipkin team does not support. Hence, direct questions to their respective communities.
    
 - [Apache SkyWalking](https://github.com/apache/incubator-skywalking)
   - When [zipkin-receiver](https://github.com/apache/incubator-skywalking/blob/master/docs/en/setup/backend/backend-receivers.md) is enabled, Skywalking exposes the same HTTP POST endpoints Zipkin does
     - http port 9411 accepts `/api/v1/spans` (thrift, json) and /api/v2/spans (json, proto) POST requests.
     - this integration uses the same encoding library and same endpoints as zipkin does.
 - [jaeger](https://github.com/jaegertracing/jaeger)
   - When `COLLECTOR_ZIPKIN_HTTP_PORT=9411` is set, Jaeger exposes a partial implementation of Zipkin's HTTP POST endpoints
     - http port 9411 accepts `/api/v1/spans` (thrift, json) and /api/v2/spans (json, but not proto) POST requests.
   - When `SPAN_STORAGE_TYPE=kafka` and `zipkin-thrift`, Jaeger reads zipkin v1 thrift encoded span messages from a Kafka topic.
     - Note: The above is a [deprecated practice](https://github.com/openzipkin/zipkin/tree/master/zipkin-collector/kafka#legacy-encoding) in Zipkin. Most instrumentation bundle multiple spans per message in v2 format.


Did we miss an integration? Please open a pull-request to
[openzipkin.github.io](https://github.com/openzipkin/openzipkin.github.io).

