---
title: Home
weight: 0
---

![Web interface screenshot]({{ site.github.url }}/public/img/web-screenshot.png)

Zipkin is a distributed tracing system. It helps gather timing data needed to
troubleshoot latency problems in microservice architectures. It manages both the
collection and lookup of this data through a Collector and a Query service.
Zipkin’s design is based on the
[Google Dapper](http://research.google.com/pubs/pub36356.html) paper.

Collecting traces helps developers gain deeper knowledge about how certain
requests perform in a distributed system. Let’s say we’re having problems with
user requests timing out. We can look up traced requests that timed out and
display it in the web UI. We’ll be able to quickly find the service responsible
for adding the unexpected response time. If the service has been annotated
adequately we can also find out where in that service the issue is happening.

## Where to go next?

 * To try out Zipkin, check out our [Quickstart guide]({{ site.github.url }}/pages/quickstart)
 * See if your platform has an [existing instrumentation library]({{ site.github.url
}}/pages/existing_instrumentations)
 * Join the [Zipkin Gitter chat channel](https://gitter.im/openzipkin/zipkin)
 * The source code is on GitHub as [openzipkin/zipkin](https://github.com/openzipkin/zipkin/)
 * Issues are also tracked on [GitHub](https://github.com/openzipkin/zipkin/issues)
