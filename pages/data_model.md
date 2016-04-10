---
title: Data Model
---

In order to illustrate the tracing data that Zipkin displays, let's relate it to the equivalent information in the Zipkin data model. By comparing these, we see that

+ inbound and outbound requests are in different spans
+ spans that include `cs` can log an `sa` annotation of where they are going
  + This helps when the destination protocol isn't Zipkin instrumented, such as MySQL.

First, we see one trace as shown in the Zipkin trace  viewer:

![Zipkin Screenshot]({{ site.github.url }}/public/img/json_zipkin_screenshot.png)

And the same trace in the data model of Zipkin:

{% highlight json %}  
  [
    [
      {
      "traceId": "bd7a977555f6b982",
      "name": "get",
      "id": "bd7a977555f6b982",
      "timestamp": 1458702548467000,
      "duration": 386000,
      "annotations": [
        {
          "endpoint[": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          },
          "timestamp": 1458702548467000,
          "value": "sr"
        },
        {
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          },
          "timestamp": 1458702548853000,
          "value": "ss"
        }
      ],
      "binaryAnnotations": []
    },
    {
      "traceId": "bd7a977555f6b982",
      "name": "get-traces",
      "id": "ebf33e1a81dc6f71",
      "parentId": "bd7a977555f6b982",
      "timestamp": 1458702548478000,
      "duration": 354374,
      "annotations": [],
      "binaryAnnotations": [
        {
          "key": "lc",
          "value": "JDBCSpanStore",
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          }
        },
        {
          "key": "request",
          "value": "QueryRequest{serviceName=zipkin-query, spanName=null, annotations=[], binaryAnnotations={}, minDuration=null, maxDuration=null, endTs=1458702548478, lookback=86400000, limit=1}",
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          }
        }
      ]
    },
    {
      "traceId": "bd7a977555f6b982",
      "name": "query",
      "id": "be2d01e33cc78d97",
      "parentId": "ebf33e1a81dc6f71",
      "timestamp": 1458702548786000,
      "duration": 13000,
      "annotations": [
        {
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          },
          "timestamp": 1458702548786000,
          "value": "cs"
        },
        {
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          },
          "timestamp": 1458702548799000,
          "value": "cr"
        }
      ],
      "binaryAnnotations": [
        {
          "key": "jdbc.query",
          "value": "select distinct `zipkin_spans`.`trace_id` from `zipkin_spans` join `zipkin_annotations` on (`zipkin_spans`.`trace_id` = `zipkin_annotations`.`trace_id` and `zipkin_spans`.`id` = `zipkin_annotations`.`span_id`) where (`zipkin_annotations`.`endpoint_service_name` = ? and `zipkin_spans`.`start_ts` between ? and ?) order by `zipkin_spans`.`start_ts` desc limit ?",
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          }
        },
        {
          "key": "sa",
          "value": true,
          "endpoint": {
            "serviceName": "spanstore-jdbc",
            "ipv4": "127.0.0.1",
            "port": 3306
          }
        }
      ]
    },
    {
      "traceId": "bd7a977555f6b982",
      "name": "query",
      "id": "13038c5fee5a2f2e",
      "parentId": "ebf33e1a81dc6f71",
      "timestamp": 1458702548817000,
      "duration": 1000,
      "annotations": [
        {
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          },
          "timestamp": 1458702548817000,
          "value": "cs"
        },
        {
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          },
          "timestamp": 1458702548818000,
          "value": "cr"
        }
      ],
      "binaryAnnotations": [
        {
          "key": "jdbc.query",
          "val[[ue": "select `zipkin_spans`.`trace_id`, `zipkin_spans`.`id`, `zipkin_spans`.`name`, `zipkin_spans`.`parent_id`, `z[ipkin_spans`.`debug`, `zipkin_spans`.`start_ts`, `zipkin_spans`.`duration` from `zipkin_spans` where `zipkin_spans`.`trace_id` in (?)",
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          }
        },
        {
          "key": "sa",
          "value": true,
          "endpoint": {
            "serviceName": "spanstore-jdbc",
            "ipv4": "127.0.0.1",
            "port": 3306
          }
        }
      ]
    },
    {
      "traceId": "bd7a977555f6b982",
      "name": "query",
      "id": "37ee55f3d3a94336",
      "parentId": "ebf33e1a81dc6f71",
      "timestamp": 1458702548827000,
      "duration": 2000,
      "annotations": [
        {
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          },
          "timestamp": 1458702548827000,
          "value": "cs"
        },
        {
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          },
          "timestamp": 1458702548829000,
          "value": "cr"
        }
      ],
      "binaryAnnotations": [
        {
          "key": "jdbc.query",
          "value": "select `zipkin_annotations`.`trace_id`, `zipkin_annotations`.`span_id`, `zipkin_annotations`.`a_key`, `zipkin_annotations`.`a_value`, `zipkin_annotations`.`a_type`, `zipkin_annotations`.`a_timestamp`, `zipkin_annotations`.`endpoint_ipv4`, `zipkin_annotations`.`endpoint_port`, `zipkin_annotations`.`endpoint_service_name` from `zipkin_annotations` where `zipkin_annotations`.`trace_id` in (?) order by `zipkin_annotations`.`a_timestamp` asc, `zipkin_annotations`.`a_key` asc",
          "endpoint": {
            "serviceName": "zipkin-query",
            "ipv4": "192.168.1.2",
            "port": 9411
          }
        },
        {
          "key": "sa",
          "value": true,
          "endpoint": {
            "serviceName": "spanstore-jdbc",
            "ipv4": "127.0.0.1",
            "port": 3306
          }
        }
      ]
    }
  ]  
 {% endhighlight %}
