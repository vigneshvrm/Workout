---
title: Elasticsearch
sidebar_label: Elasticsearch
---

|**`Version Latest` `OS Ubuntu 20.04` `Monitoring`**|  |
|-------------------------------------------------------|--|

### Description

Elasticsearch is an open-source search and analytics engine based on Apache Lucene that is extremely scalable and distributed. It is intended to manage massive amounts of data while also providing rapid and versatile search capabilities for a variety of applications. Elasticsearch, developed by Elastic, has become a critical component in current data-driven projects, allowing users to store, search, and analyse massive volumes of data in near real-time.

### Software Included

Java - 11
Elasticsearch - 8.X

### Aloow the ports on the firewall Elasticsearch

One you have deployed the Elasticsearch on your instance kindly allow the port 9200 The elastic search uses this port to listens for HTTP traffic. Currently we have exposed the elastic serach to globally. So kindly the network host expose this node on the network and configure the cluster nodes and the networks in the file.

~~~
/etc/elasticsearch/elasticsearch.yml
~~~


