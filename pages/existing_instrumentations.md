---
title: Existing instrumentations
weight: 3
---

Tracing information is collected on each host using the instrumented libraries
and sent to Zipkin. When the host makes a request to another service, it passes
a few tracing identifers along with the request so we can later tie the data
together.

The following libraries exist to provide instrumentation on various platforms.
Please refer to their individual documentation for setup and configuration
guides.

| Language | Library | Framework | Transports Supported | Sampling Supported? | Other notes |
|:---------|:--------|:----------|:---------------------|:--------------------|:------------|
| Python | [pyramid_zipkin](https://github.com/Yelp/pyramid_zipkin) | [Pyramid](http://docs.pylonsproject.org/projects/pyramid/en/latest/) |[Kafka \| Scribe](http://pyramid-zipkin.readthedocs.org/en/latest/configuring_zipkin.html#zipkin-transport-handler) | [Yes](http://pyramid-zipkin.readthedocs.org/en/latest/configuring_zipkin.html#zipkin-tracing-percent) | py2, py3 support. |
| Java | [brave](https://github.com/openzipkin/brave) | Jersey, RestEASY, JAXRS2, Apache HttpClient, Mysql | Http, Kafka, Scribe | Yes | Java 7 or higher|
| Java | [finagle-zipkin](https://github.com/twitter/finagle/tree/develop/finagle-zipkin) | Scribe | [Finagle](https://github.com/twitter/finagle) | Yes | |
| Ruby | [zipkin-tracer](https://github.com/openzipkin/zipkin-tracer) | [Rack](http://rack.github.io/) | Http, Kafka, Scribe | Yes | lc support. Ruby 2.0 or higher|
| C# | [ZipkinTracerModule](https://github.com/mdsol/Medidata.ZipkinTracerModule) | OWIN, HttpHandler | Http | Yes | lc support. 4.5.2 or higher |
| Go | [go-zipkin](https://github.com/elodina/go-zipkin) | x/net Context | Kafka | Yes | |
{: .wide-table}

Did we miss a library? Please open a pull-request to
[openzipkin.github.io](https://github.com/openzipkin/openzipkin.github.io).

Want to create instrumentation for another framework / platform? We have documentation on [instrumenting a library]({{ site.github.url }}/pages/instrumenting).
