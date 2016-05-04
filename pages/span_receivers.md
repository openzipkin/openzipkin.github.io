---
title: Zipkin collectors
---

A collector is responsible for collecting spans from services, converting
them to a Zipkin common Span, and passing them to the storage layer. This
approach is modular which allows for collectors that accept any type of data
from any producer. Zipkin comes with collectors for HTTP, Kafka, and Scribe.
