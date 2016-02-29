---
title: Architecture
weight: 2
---


These are the components that make up a fully fledged tracing system.

![Architecture overview]({{ site.github.url }}/public/img/architecture-0.png)

Instrumented libraries
----------------------

Tracing information is collected on each host using the instrumented libraries
and sent to Zipkin. When the host makes a request to another service, it passes
a few tracing identifers along with the request so we can later tie the data
together.

![Instrumentation architecture]({{ site.github.url }}/public/img/architecture-1.png)

To see if an instrumentation library already exists for your platform, see the
list of [existing instrumentations]({{ site.github.url
}}/pages/existing_instrumentations).

Transport
---------

Spans must be transported from the services being traced to Zipkin collectors.
There are two primary transports, Scribe and Kafka. Scribe is deprecated.

Zipkin Collector
----------------

Once the trace data arrives at the Zipkin collector daemon we check that it's
valid, store it and the index it for lookups.

Storage
-------

We originally built Zipkin on Cassandra for storage. It's scalable, has a
flexible schema, and is heavily used within Twitter. However, we made this
component pluggable, and we now have support for Redis and MySQL.

Zipkin Query Service
--------------------

Once the data is stored and indexed we need a way to extract it. This is where
the query daemon comes in, providing a simple JSON api for finding and retrieving
traces. The primary consumer of this api is the Web UI.

Web UI
------

A GUI that presents a nice face for viewing traces. The web UI provides a
method for viewing traces based on service, time, and  annotations. Note
that there is no built in authentication in the UI.
