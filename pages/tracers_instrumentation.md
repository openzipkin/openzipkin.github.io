---
title: Tracers and Instrumentation
weight: 3
---

Tracing information is collected on each host using the instrumented libraries
and sent to Zipkin. When the host makes a request to another application, it passes
a few tracing identifiers along with the request to Zipkin so we can later tie the data
together into spans.

The following libraries exist to provide instrumentation on various platforms.
Please refer to their individual documentation for setup and configuration
guides.

### OpenZipkin supported

The following libraries are supported by the OpenZipkin team and are hosted at
the [OpenZipkin GitHub](https://github.com/openzipkin/) group. You can reach out to
the team on [Zipkin Gitter](https://gitter.im/openzipkin/zipkin/) chat.

| Language | Library | Framework | Propagation Supported | Transports Supported | Sampling Supported? | Other notes |
|:---------|:--------|:----------|:----------------------|:---------------------|:--------------------|:------------|{% for lib in site.data.openzipkin_tracers_instrumentation %}
| {{ lib.language }} | {{ lib.library }} | {{lib.framework}} | {{ lib.propagation }} | {{ lib.transports }} | {{ lib.sampling }} | {{ lib.notes }} |{% endfor %}
{: .wide-table}


### Community supported

| Language | Library | Framework | Propagation Supported | Transports Supported | Sampling Supported? | Other notes |
|:---------|:--------|:----------|:----------------------|:---------------------|:--------------------|:------------|{% for lib in site.data.community_tracers_instrumentation %}
| {{ lib.language }} | {{ lib.library }} | {{lib.framework}} | {{ lib.propagation }} | {{ lib.transports }} | {{ lib.sampling }} | {{ lib.notes }} |{% endfor %}
{: .wide-table}

Did we miss a library? Please open a pull-request to
[openzipkin.github.io](https://github.com/openzipkin/openzipkin.github.io).

Want to create instrumentation for another framework or platform? We have documentation on [instrumenting a library]({{ site.github.url }}/pages/instrumenting).
