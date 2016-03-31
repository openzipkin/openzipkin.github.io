---
title: Transports
---

A transport is responsible for collecting spans from services, converting
them to a Zipkin common Span, and passing them to the storage layer. This
approach is modular which allows for transports that accept any type of data
from any producer. Zipkin comes with transports for HTTP, Kafka, and Scribe.
