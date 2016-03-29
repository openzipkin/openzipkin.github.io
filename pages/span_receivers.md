---
title: Span Receivers
---

A `SpanReceiver` is responsible for collecting spans from services, converting
them to a Zipkin common Span, and passing them to the storage layer. This
approach is modular which allows for receivers that accept any type of data
from any producer. Zipkin comes with a receiver for Scribe and one for
Kafka.

Scribe Receiver
---------------

Scribe was the logging framework in use at Twitter to transport trace data when
Zipkin was created.

For small architectures, tracers can be setup to send directly to the Zipkin
collectors. The `ScribeSpanReceiver` expects a Scribe log entry with a Base64-encoded, binary serialized thrift Span using the "zipkin" category. This
category is configurable via a command line flag. Finagle-Zipkin does this
automatically.
