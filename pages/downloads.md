---
title: Source Downloads
weight: 4
---
{% comment %}Not all mirrors propagate asc and sha512 files{% endcomment %}
{% assign mirrorUrl = 'https://www.apache.org/dyn/closer.cgi?path=incubator/zipkin' %}
{% assign baseUrl = 'https://www.apache.org/dist/incubator/zipkin' %}

Apache Software Foundation (ASF) requires projects to have a downloads page, used in release announcements. Below are the locations of the official voted source releases per-project.

If you like, you can [verify](https://www.apache.org/info/verification) the source downloads using Zipkin's [KEYS file](https://www.apache.org/dist/incubator/zipkin/KEYS).

{% assign downloads = site.data.downloads | where_exp: "download", "download.type != 'internal'" %}

| Name | Version | Source | Signature | Checksum |
|:---- |:--------|:-------|:----------|:-------- |{% for download in downloads %}{% capture zip %}{{ download.module }}/{{ download.version }}/apache-{{ download.repo }}-incubating-{{ download.version }}-source-release.zip{% endcapture %}{% capture releaseNotes %}https://github.com/apache/incubator-{{ download.repo }}/releases/tag/v{{ download.version }}{% endcapture %}
| {{ download.friendlyName }} | [{{ download.version }}]({{ releaseNotes }}) | [zip]({{ mirrorUrl }}/{{ zip }}) | [asc]({{ baseUrl }}/{{ zip }}.asc) | [sha512]({{ baseUrl }}/{{ zip }}.sha512) |{% endfor %}
{: .wide-table}

### Internal Tools
The following tools are not for general use, but are listed in order to comply with Apache Software Foundation (ASF) release policy.

{% assign internalDownloads = site.data.downloads | where_exp: "download", "download.type == 'internal'" %}

| Name | Version | Source | Signature | Checksum |
|:---- |:--------|:-------|:----------|:-------- |{% for download in internalDownloads %}{% capture zip %}{{ download.module }}/{{ download.version }}/apache-{{ download.repo }}-incubating-{{ download.version }}-source-release.zip{% endcapture %}{% capture releaseNotes %}https://github.com/apache/incubator-{{ download.repo }}/releases/tag/v{{ download.version }}{% endcapture %}
| {{ download.friendlyName }} | [{{ download.version }}]({{ releaseNotes }}) | [zip]({{ mirrorUrl }}/{{ zip }}) | [asc]({{ baseUrl }}/{{ zip }}.asc) | [sha512]({{ baseUrl }}/{{ zip }}.sha512) |{% endfor %}
{: .wide-table}



