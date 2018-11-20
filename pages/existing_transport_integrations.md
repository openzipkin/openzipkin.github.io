---
title: Existing server integrations
weight: 4
---

### Server integrations
The spans collected through the instrument API are collected by the zipkin collector and stored in the designated storage.
The Zipkin server build already integrates http, kafka, rabbitMQ collectors, cassandra, elasticsearch and mysql storage.
Server integration extends collector or storage.

| Type | Library | Related product | Other notes |
|:-----|:--------|:----------------|:------------|{% for lib in site.data.transport_integrations %}
| {{ lib.type }} | {{ lib.library }} | {{lib.product}} | {{ lib.notes }} |{% endfor %}
{: .wide-table}



### Zipkin compatible servers
The following Zipkin compatible servers receive and process zipkin formatted data.
    
 - [Skywalking](https://github.com/apache/incubator-skywalking)
   - accept Zipkin v1/v2 spans 
 - [jaeger](https://github.com/jaegertracing/jaeger)
   - accept Zipkin v1/v2 spans 



Did we miss a library? Please open a pull-request to
[openzipkin.github.io](https://github.com/openzipkin/openzipkin.github.io).

