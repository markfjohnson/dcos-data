# Installation notes for the DC/OS Data Demo Labs

## Requirements
* AWS Login
* DC/OS Enterprise License


## Installation Overview
The ```setup_demo.sh``` script setups the key components required for the demo.  After this script has successfully completed, the following items will be installed and configured in preparation for each of the demo labs.
* Cassandra secured with service accounts and having 3 data nodes
* Eddge-LB configured for Cassandra and secured with the edge-lb service account
* Prometheus and Grafana to report on Cassandra Read/Write performance
* 2 Kubernetes clusters which will get used for running the cassandra demos

**NOTE:** Make certain this script has run and all services healthy before proceeding to the Labs.

## Lab 1: Cassandra HA and scalability demo

### Pain Points addressed:
* Avoid Data and throughput loss on failure
* Maximize Cassandra performance without lots of training
* Maintain performance even