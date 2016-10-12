---
title: Architecture
weight: 2
---

Architecture Overview
----------------------

Tracers live in your applications and record timing and metadata about
operations that that took place. They often instrument libraries, so that their
use is transparent to users. For example, an instrumented web server records
when it received a request and when it sent a response. The trace data collected
is called a Span.

Instrumentation is written to be safe in production and have little overhead.
For this reason, they only propagate IDs in-band, to tell the receiver there’s
a trace in progress. Completed spans are reported to zipkin out-of-band,
similar to how applications report metrics asynchronously.

For example, when an operation is being traced and it needs to make an outgoing
http request, a few headers are added to propagate IDs. Headers are not used to
send details such as the operation name.

The component in an instrumented app that sends data to Zipkin is called a
Reporter. Reporters send trace data via one of several transports to Zipkin
collectors, which persist trace data to storage. Later, storage is queried by
the API to provide data to the UI.

Here's a diagram describing this flow:

![Zipkin architecture]({{ site.github.url }}/public/img/architecture-1.png)

To see if an instrumentation library already exists for your platform, see the
list of [existing instrumentations]({{ site.github.url}}/pages/existing_instrumentations).


Transport
---------

Spans sent by the instrumented library must be transported from the services being traced to Zipkin collectors.
There are two primary transports: Scribe and Kafka. Scribe is shown in the figure. See [Span Receivers]({{ site.github.url }}/pages/span_receivers) for more information.

There are 4 components that make up Zipkin:

* collector
* storage
* search
* web UI

### Zipkin Collector

Once the trace data arrives at the Zipkin collector daemon, it is validated, stored, and indexed for lookups by the Zipkin collector.

### Storage

Zipkin was initially built to store data on Cassandra since Cassandra is scalable, has a
flexible schema, and is heavily used within Twitter. However, we made this
component pluggable. In addition to Cassandra, we support ElasticSearch and MySQL.

### Zipkin Query Service

Once the data is stored and indexed, we need a way to extract it. The query daemon provides a simple JSON API for finding and retrieving traces. The primary consumer of this API is the Web UI.

### Web UI

We created a GUI that presents a nice interface for viewing traces. The web UI provides a
method for viewing traces based on service, time, and annotations.
Note: there is no built-in authentication in the UI!
