---
title: Home
weight: 0
---

![Web interface screenshot]({{ site.github.url }}/public/img/web-screenshot.png)

Zipkin is a distributed tracing system. It helps gather timing data needed to
troubleshoot latency problems in microservice architectures. It manages both the
collection and lookup of this data.
Zipkin’s design is based on the
[Google Dapper](http://research.google.com/pubs/pub36356.html) paper.

Applications are instrumented to report timing data to Zipkin. The Zipkin UI also presents a Dependency diagram showing how many traced requests went through each application. If you are troubleshooting latency problems or errors, you can filter or sort all traces based on the application, length of trace, annotation, or timestamp. Once you select a trace, you can see the percentage of the total trace time each span takes which allows you to identify the problem application. 

## Where to go next?

 * To try out Zipkin, check out our [Quickstart guide]({{ site.github.url }}/pages/quickstart)
 * See if your platform has an [existing instrumentation library]({{ site.github.url
}}/pages/existing_instrumentations)
 * Join the [Zipkin Gitter chat channel](https://gitter.im/openzipkin/zipkin)
 * The source code is on GitHub as [openzipkin/zipkin](https://github.com/openzipkin/zipkin/)
 * Issues are also tracked on [GitHub](https://github.com/openzipkin/zipkin/issues)
