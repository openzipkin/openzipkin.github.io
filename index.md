---
title: Home
weight: 0
---
Zipkin is a distributed tracing system. It helps gather timing data needed to troubleshoot latency problems in service architectures. Features include both the collection and lookup of this data.

If you have a trace ID in a log file, you can jump directly to it. Otherwise, you can query based on attributes such as service, operation name, tags and duration. Some interesting data will be summarized for you, such as the percentage of time spent in a service, and whether or not operations failed.

![Trace view screenshot]({{ site.github.url }}/public/img/web-screenshot.png)

The Zipkin UI also presents a Dependency diagram showing how many traced requests went through each application. This can be helpful for identifying aggregate behavior including error paths or calls to deprecated services.

![Dependency graph screenshot]({{ site.github.url }}/public/img/dependency-graph.png)

Application's need to be "instrumented" to report trace data to Zipkin. This usually means configuration of a [tracer or instrumentation library]({{ site.github.url }}/pages/tracers_instrumentation). The most popular ways to report data to Zipkin are via http or Kafka, though many other options exist, such as Apache ActiveMQ, gRPC and RabbitMQ. The data served to the UI is stored in-memory, or persistently with a supported backend such as Apache Cassandra or Elasticsearch.

## Where to go next?

 * To try out Zipkin, check out our [Quickstart guide]({{ site.github.url }}/pages/quickstart)
 * See if your platform has a [tracer or instrumentation library]({{ site.github.url }}/pages/tracers_instrumentation)
 * See if a [server extension or alternative]({{ site.github.url }}/pages/extensions_choices) is relevant to your site.
 * Join the [Zipkin Gitter chat channel](https://gitter.im/openzipkin/zipkin)
 * The source code is on GitHub as [openzipkin/zipkin](https://github.com/openzipkin/zipkin/)
 * Issues are also tracked on [GitHub](https://github.com/openzipkin/zipkin/issues)
