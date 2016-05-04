---
title: Architecture
weight: 2
---



Instrumented libraries
----------------------

Tracing data is collected on each host using the instrumented libraries
and sent to Zipkin. When the host makes a request to another service, it passes
a few tracing identifiers along with the request so we can later tie the data
together.

![Instrumentation architecture]({{ site.github.url }}/public/img/architecture-1.png)

To see if an instrumentation library already exists for your platform, see the
list of [existing instrumentations]({{ site.github.url}}/pages/existing_instrumentations).

Transport
---------

Tracing data sent by the instrumented library must be transported from the services being traced to Zipkin collectors.
There are two primary transports: HTTP and Kafka. Scribe can also be used.
See [Span Receivers]({{ site.github.url }}/pages/span_receivers) for more information.

![Architecture overview]({{ site.github.url }}/graphs/architecture/graph.png)
There are 4 components that make up Zipkin:

* collector
* database
* query
* web UI




### Zipkin Collector

Once the trace data arrives at the Zipkin collector daemon, it is validated, stored, and indexed for lookups by the Zipkin collector.

### Database

Zipkin was initially built to store data on Cassandra since Cassandra is scalable, has a
flexible schema, and is heavily used within Twitter. However, we made this
component pluggable. In addition to Cassandra, we support ElasticSearch and MySQL.

### Zipkin Query Service

Once the data is stored and indexed, we need a way to extract it. The query daemon provides a simple JSON API for finding and retrieving traces. The primary consumer of this API is the Web UI.

### Web UI

We created a GUI that presents a nice interface for viewing traces. The web UI provides a
method for viewing traces based on service, time, and annotations.
Note: there is no built-in authentication in the UI!
