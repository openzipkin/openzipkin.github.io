---
title: Instrumenting a library
---

This is an advanced topic. Before reading further, you may want to check whether
an instrumentation library for your platform [already exists]({{ site.github.url
}}/pages/existing_instrumentations). If not and if you want to take on creating an instrumentation library, first things first; jump on
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



Alright, ready? Here we go.

Core data structures
=====

First, there are a core set of structures that we need:

**Annotation**

An Annotation is used to record an event and when it occurs. There's a set of core
annotations used to define the beginning and end of a request:

* **cs** - Client Start. The client has made the request. This sets the beginning of the span.
* **sr** - Server Receive: The server has received the request and will start processing it. The difference between this and `cs` will be combination of network latency and clock jitter.
* **ss** - Server Send: The server has completed processing and has sent the request back to the client. The difference between this and `ss` will be the amount of time it took the server to process the request.
* **cr** - Client Receiver: The client has received the response from the server. This sets the end of the span. The RPC is considered complete when this annotation is recorded.

Other annotations can be recorded during the request's lifetime in order to
provide further insight. For instance, adding an annotation when a server begins
and ends an expensive computation may provide insight into how much time is
being spent pre- and post-processing the request versus how much time is spent
running the calculation.

**BinaryAnnotation**

Binary annotations do not have a time component. They are meant to provide extra information about the RPC. For instance when calling an HTTP service, providing
the URI of the call will help with later analysis of requests coming into the service.

**Span**

A set of Annotations and BinaryAnnotations that correspond to a particular RPC.
Spans contain identifying information such as traceId, spandId, parentId, and
RPC name.

**Trace**

A set of spans that share a single root span. Traces are built by collecting all
Spans that share a traceId. The spans are then arranged in a tree based on
spanId and parentId, thus providing an overview of the path a request takes
through the system.

Trace identifiers
=====

Second, two pieces of information are required in order to reassemble a set of spans into a full trace; a third piece is optional. These are all 64 bits long.

**Trace Id**

The overall ID of the trace. Every span in a trace will share this ID.

**Span Id**

The ID for a particular span. This may or may not be the same as the trace id. If a trace contains only one span, the Span ID and Trace ID can be the same. If not, the IDs should be different.

**Parent Id**

This is an optional ID that will only be present in child spans. The span without a parent id is considered the root of the trace.

Generating identifiers
----------------------

Next, let's walk through how Spans are identified.

For the initial receipt of a request, no trace information exists. So we create a
trace id and span id. These should be 64 random bits. The span id can be the same
as the trace id.

If the request already has trace information attached to it, the service should
use that information since `sr` and `ss` events are part of the
same span as the `cs` and `cr` events

If the service calls out to a downstream service, a new span is created as a
child of the former span. It is identified by the same trace id, a new span id,
and the parent id is set to the span id of the previous span. The new span id
should be 64 random bits.

**Note** This process must be repeated if the service makes multiple downstream
calls. That is, each subsequent span will have the same trace id and parent id,
but a new and different span id.

Communicating trace information
-------------------------------

Finally, trace information needs to be passed between upstream and downstream services in
order to reassemble a complete trace.  Five pieces of information are required:

* Trace Id
* Span Id
* Parent Id
* Sampled
* Flags

** Sampled**

Lets the downstream service know if it should record trace
information for the request.

** Flags**

Provides the ability to create and communicate feature flags. This is how
we can tell downstream services that this is a "debug" request.

Check [here](https://github.com/openzipkin/brave/blob/e474ed1e1cd291c7ebc6830c58fdba0a6318fdd2/brave-http/src/main/java/com/github/kristofa/brave/http/BraveHttpHeaders.java) for the format

Finagle provides mechanisms for passing this information with HTTP and Thrift
requests. Other protocols will need to be augmented with the information for
tracing to be effective.

**HTTP Tracing**

HTTP headers are used to pass along trace information.

The B3 portion of the header is so named for the original name of Zipkin:
BigBrotherBird.

Ids are encoded as [hex strings](https://github.com/twitter/finagle/blob/master/finagle-core/src/main/scala/com/twitter/finagle/tracing/Id.scala):

* X-B3-TraceId: 64 encoded bits
* X-B3-SpanId: 64 encoded bits
* X-B3-ParentSpanId: 64 encoded bits
* X-B3-Sampled: Boolean (either "1" or "0")
* X-B3-Flags: a Long string

**Thrift Tracing**

Finagle clients and servers negotiate whether they can handle extra information
in the header of the thrift message when a connection is established. Negotiated trace data is packed into the front of each thrift message.
