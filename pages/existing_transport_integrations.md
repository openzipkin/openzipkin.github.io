---
title: Existing server integrations
weight: 4
---

### OpenZipkin server integrations
The spans collected through the instrument API are collected by the zipkin collector and stored in the designated storage.
The Zipkin server build already integrates http, kafka, rabbitMQ collectors, cassandra, elasticsearch and mysql storage.
Server integration extends collector or storage.

| Type | Library | Related product | Other notes |
|:-----|:--------|:----------------|:------------|{% for lib in site.data.transport_integrations %}
| {{ lib.type }} | {{ lib.library }} | {{lib.product}} | {{ lib.notes }} |{% endfor %}
{: .wide-table}



### Community Server Alternatives
The following Zipkin compatible servers receive and process zipkin formatted data.
    
 - [Skywalking](https://github.com/apache/incubator-skywalking)
   - When [zipkin-receiver](https://github.com/apache/incubator-skywalking/blob/master/docs/en/setup/backend/backend-receivers.md) is enabled, Skywalking exposes the same HTTP POST endpoints Zipkin does
     - http port 9411 accepts `/api/v1/spans` (thrift, json) and /api/v2/spans (json, proto) POST requests.
     - this integration uses the same encoding library and same endpoints as zipkin does.
 - [jaeger](https://github.com/jaegertracing/jaeger)
   - accept Zipkin v1/v2 spans 



Did we miss a library? Please open a pull-request to
[openzipkin.github.io](https://github.com/openzipkin/openzipkin.github.io).

