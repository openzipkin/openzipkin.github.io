---
title: Instrumenting a library
---

This is an advanced topic. Before reading further, you may want to check whether
an instrumentation library for your platform [already exists]({{ site.github.url
}}/pages/tracers_instrumentation). If not and if you want to take on creating an instrumentation library, first things first; jump on
[Zipkin Gitter chat channel](https://gitter.im/openzipkin/zipkin) and let us know. We'll be extremely
happy to help you along the way.
{: .message}

Overview
=======

To instrument a library, you'll need to understand and create the following elements:

1. Core data structures - the information that is collected and sent to Zipkin
1. Trace identifiers - what tags for the information are needed so it can be reassembled in a logical order by Zipkin
  * Generating identifiers - how to generate these IDs and which IDs should be inherited
  * Communicating trace information - additional information that is sent to Zipkin along with the traces and their IDs.
1. Timestamps and duration - how to record timing information about an operation.


Alright, ready? Here we go.

Core data structures
=====

Core data structures are documented in detail in [Thrift](https://github.com/openzipkin/zipkin-api/blob/master/thrift/zipkinCore.thrift) comments. Here's a high-level description to get you started:

**Annotation**

An Annotation is used to record an occurrence in time. There's a set of core
annotations used to define the beginning and end of an RPC request:

* **cs** - Client Send. The client has made the request. This sets the
  beginning of the span.
* **sr** - Server Receive: The server has received the request and will start
  processing it. The difference between this and `cs` will be combination of
  network latency and clock jitter.
* **ss** - Server Send: The server has completed processing and has sent the
  request back to the client. The difference between this and `sr` will be the
  amount of time it took the server to process the request.
* **cr** - Client Receive: The client has received the response from the server.
  This sets the end of the span. The RPC is considered complete when this
  annotation is recorded.

When using message brokers instead of RPCs, the following annotations help
clarify the direction of the flow:

* **ms** - Message Send: The producer sends a message to a broker.
* **mr** - Message Receive: A consumer received a message from a broker.

Unlike RPC, messaging spans never share a span ID. For example, each consumer
of a message is a different child span of the producing span.

Other annotations can be recorded during the request's lifetime in order to
provide further insight. For instance adding an annotation when a server begins
and ends an expensive computation may provide insight into how much time is
being spent pre and post processing the request versus how much time is spent
running the calculation.

**BinaryAnnotation**

Binary annotations do not have a time component. They are meant to provide extra
information about the RPC. For instance when calling an HTTP service, providing
the URI of the call will help with later analysis of requests coming into the
service. Binary annotations can also be used for exact match search in the
Zipkin Api or UI.

**Endpoint**
Annotations and binary annotations have an endpoint associated with them. With two
exceptions, this endpoint is associated with the traced process. For example, the
service name drop-down in the Zipkin UI corresponds with Annotation.endpoint.serviceName
or BinaryAnnotation.endpoint.serviceName. For the sake of usability, the cardinality
of Endpoint.serviceName should be bound. For example, it shouldn't include variables
or random numbers.


**Span**

A set of Annotations and BinaryAnnotations that correspond to a particular RPC.
Spans contain identifying information such as traceId, spanId, parentId, and
RPC name.

Spans are usually small. For example, the serialized form is often measured in
KiB or less. When spans grow beyond orders of KiB, other problems occur, such as
hitting limits like Kafka message size (1MiB). Even if you can raise message
limits, large spans will increase the cost and decrease the usability of the
tracing system. For this reason, be conscious to store data that helps explain
system behavior, and don't store data that doesn't.

**Trace**

A set of spans that share a single root span. Traces are built by collecting all
Spans that share a traceId. The spans are then arranged in a tree based on
spanId and parentId thus providing an overview of the path a request takes
through the system.

Trace identifiers
=====

In order to reassemble a set of spans into a full trace three pieces of
information are required. Trace identifiers can be 128-bit, but span identifiers
within a trace are always 64-bit.

**Trace Id**

The overall 64 or 128-bit ID of the trace. Every span in a trace shares this ID.

**Span Id**

The ID for a particular span. This may or may not be the same as the
trace id.

**Parent Id**

This is an optional ID that will only be present on child spans. That is the
span without a parent id is considered the root of the trace.

Generating identifiers
----------------------

Let's walk through how Spans are identified.

When an incoming request has no trace information attached, we generate a random
trace ID and span ID. The span ID can be reused as the lower 64-bits of the
trace ID, but it can also be completely different.

If the request already has trace information attached to it, the service should
use that information as server receive and server send events are part of the
same span as the client send and client receive events

If the service calls out to a downstream service a new span is created as a
child of the former span. It is identified by the same trace id, a new span id,
and the parent id is set to the span id of the previous span. The new span id
should be 64 random bits.

**Note** This process must be repeated if the service makes multiple downstream
calls. That is each subsequent span will have the same trace id and parent id,
but a new and different span id.

Communicating trace information
-------------------------------

Trace information needs to be passed between upstream and downstream services in
order to reassemble a complete trace.  Five pieces of information are required:

* Trace Id
* Span Id
* Parent Id
* Sampled - Lets the downstream service know if it should record trace
information for the request.
* Flags - Provides the ability to create and communicate feature flags. This is how
we can tell downstream services that this is a "debug" request.

Check [here](https://github.com/openzipkin/b3-propagation) for the format.

[Finagle](https://twitter.github.io/finagle/) provides mechanisms for passing this information with HTTP and Thrift
requests. Other protocols will need to be augmented with the information for
tracing to be effective.

**Instrumentation sampling decisions are made at the edge of the system**

Downstream services must honour the sampling decision of the upstream system. If
there's no "Sampled" information in the incoming request, the library should
make a decision on whether to sample this request, and include the decision in
further downstream requests. This simplifies the math when it comes to
understanding what's sampled and what isn't. It also ensures that a request is
either fully traced, or not traced at all, making the sampling policy easier to
understand and configure.

Note that the debug flag will force a trace to be sampled, regardless of any
sampling rules. The debug flag also applies to storage tier sampling, which is
configured on the server side of Zipkin.

**HTTP Tracing**

HTTP headers are used to pass along trace information.

The B3 portion of the header is so named for the original name of Zipkin:
BigBrotherBird.

Ids are encoded as [hex strings](https://github.com/twitter/finagle/blob/master/finagle-core/src/main/scala/com/twitter/finagle/tracing/Id.scala):

* X-B3-TraceId: 128 or 64 lower-hex encoded bits (required)
* X-B3-SpanId: 64 lower-hex encoded bits (required)
* X-B3-ParentSpanId: 64 lower-hex encoded bits (absent on root span)
* X-B3-Sampled: Boolean (either "1" or "0", can be absent)
* X-B3-Flags: "1" means debug (can be absent)

For more information on B3, please see its [specification](https://github.com/openzipkin/b3-propagation).

**Thrift Tracing**

Finagle clients and servers negotate whether they can handle extra information
in the header of the thrift message when a connection is established. Once
negotiated trace data is packed into the front of each thrift message.

Timestamps and duration
=====

Span recording is when timing information or metadata is structured and reported
to zipkin. One of the most important parts of this process is appropriately
recording timestamps and duration.

**Timestamps are microseconds**

All Zipkin timestamps are in epoch microseconds (not milliseconds). This value
should use the most precise measurement available. For example, `clock_gettime`
or simply multiply epoch milliseconds by 1000. Timestamps fields are stored as
64bit signed integers eventhough negative is invalid.

Microsecond precision primarily supports "local spans", which are in-process
operations. For example, with higher precision, you can tell nuances of what
happened before something else.

All timestamps have faults, including clock skew between hosts and the chance of
a time service resetting the clock backwards. For this reason, spans should
record their duration when possible.

**Span duration is also microseconds**

While it is possible to get nanosecond-precision timing information, Zipkin uses
microsecond granularity. Here are some reasons why:

First, using the same unit as timestamps makes math easier. For example, if you
are troubleshooting a span, it is easier to identify with terms in the same unit.

Next, the overhead of recording a span is often variable and can be microseconds
or more: suggesting a higher resolution than overhead can be distracting.

Future versions of Zipkin may revisit this topic, but for now, everything is
microseconds.

**When to set Span.timestamp and duration**

Span.timestamp and duration should only be set by the host that started the span.

The simplest logic is generally this:

```
unless (logging "sr" in an existing span) {
 set Span.timestamp and duration
}
```

Zipkin merges spans together that share the same trace and span ID. The most
common case of this is to merge a span reported by both the client (cs, cr) and
the server (sr, ss). For example, the client starts a span, logging "cs" and
propagates it via B3 headers, the server continues that span by logging "sr".

In this case, the client started the span, so it should record Span.timestamp and
duration, and those values should match the difference between "cs" and "cr". The
server did not start this span, so it should not set Span.timestamp or duration.

Another common case is when a server starts a root span from an uninstrumented
client, such as a web browser. It knows it should start a trace because none was
present in B3 headers or similar. Since it started the trace, it should record
Span.timestamp and duration on the root span.

Note: When a span is incomplete, you could set Span.timestamp, but not duration as
there's not enough information to do that accurately.

**What happens when Span.timestamp and duration are not set?**

Span.timestamp and Span.duration are fields added in 2015, 3 years after Zipkin
started. Not all libraries log these. When these fields are not set, Zipkin adds
them at query time (not collection time); this is not ideal.

The [duration query](http://zipkin.io/zipkin-api/#/paths/%252Ftraces/get/parameters/minDuration)
will not work as there's no data to query. Also, local (in-process) spans aren't required
to have annotations, so they cannot be queried unless their timestamp is set.

When duration isn't set by instrumentation, Zipkin tries to derive duration at query time,
it has to use the problematic method of timestamp math. Ex. if an NTP update happened inside
the span, the duration Zipkin caculates will be wrong.

Finally, there's a desire for many to move to single-host spans. The migration path
towards this is to split dual-host RPC spans into two. When instrumentation logs timestamp
only for spans it owns, splitting collectors have a heuristic to distinguish a server-initiated
root span from a client-initiated, dual-host one.

The bottom-line is that choosing not to record Span.timestamp and duration will result
in less accurate data and less functionality. Since it is very easy to record these authoritatively
before reporting, all Zipkin instrumentation should do it or ask someone to help them do it.

Message Tracing
===============

Message Tracing is different than RPC tracing because the producer and consumer
don't share span IDs.

In normal RPC tracing, client and server annotations go on the same span. This
doesn't work for messaging because there may be multiple consumers for a given
message. The trace context propagated to the consumer is the parent.

Messaging tracing doesn't have a response path. Only two annotations are used:
"ms" and "mr". Like RPC tracing, it is fine to set Span.timestamp and duration
as the producer and each consumer use separate spans.

So, the producer adds "ms" to a span and reports it to zipkin. Then, each
consumer creates a child span adding "mr" to it.

Here's a diagram of Message tracing:

```
   Producer Tracer                                    Consumer Tracer
+------------------+                               +------------------+
| +--------------+ |     +-----------------+       | +--------------+ |
| | TraceContext |======>| Message Headers |========>| TraceContext | |
| +--------------+ |     +-----------------+       | +--------------+ |
+--------||--------+                               +--------||--------+
   start ||                                                 ||
         \/                                          finish ||
span(context).annotate("ms")                                \/
             .address("ma", broker)          span(context).annotate("mr")
                                                          .address("ma", broker)
```

Here's an example of this process using the [Brave Tracer](https://github.com/openzipkin/brave):

Producer side:
```java
// Add trace identifiers to the outbound span
tracing.propagation().injector(Message::addHeader)
       .inject(span.context(), message);

producer.send(message);

// start and finish the producer side
span.kind(Span.Kind.PRODUCER)
    .remoteEndpoint(broker.endpoint())
    .start().finish();

// The above will report to zipkin trace identifiers, a "ms" annotation with the
// endpoint of the producer, and a "ma" (Message Address) with the endpoint of
// the broker
```

Consumer side:
```java
// Parse the span from message headers
TraceContextOrSamplingFlags result =
    tracing.propagation().extractor(Message::getHeader).extract(message);

// Reuse the same span ids by joining that context
span = tracer.newChild(result.context())

// start and finish the consumer side indicating the message arrived.
span.kind(Span.Kind.CONSUMER)
    .remoteEndpoint(broker.endpoint())
    .start().finish();

// The above will report to zipkin trace identifiers, a "mr" annotation with the
// endpoint of the consumer, and a "ma" (Message Address) with the endpoint of
// the broker.
```

Many consumers act in bulk, receiving many messages at the same time. It may be
helpful to inject each consumer span's trace context into its corresponding
message headers. This allows a processor to create a child later, at the right
place in the trace tree.

Here's an example of doing this with Kafka's poll api:

```java
public ConsumerRecords<K, V> poll(long timeout) {
  ConsumerRecords<K, V> records = delegate.poll(timeout);
  for (ConsumerRecord<K, V> record : records) {
    handleConsumed(record);
  }
  return records;
}

void handleConsumed(ConsumerRecord record) {
  // notifies zipkin the record arrived
  Span span = startAndFinishConsumerSpan(record);
  // allows a processor to see the parent ID (the consumer trace context)
  injector.inject(span.context(), record.headers());
}
```
