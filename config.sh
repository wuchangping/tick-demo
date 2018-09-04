#!/usr/bin/env bash
BP=$(pwd)

# Name of cluster 
CLUSTER=tick-demo-1

# Name of gcloud project
PROJECT=pravega-dev

# gcloud region
REGION=us-west1

# gcloud zone
ZONE=us-west1-b

# num GB of disk for nodes 
DISK=100

# gcloud instance types
MACHINE=n1-standard-1

# Number of nodes for kubernetes cluster
NUM_NODES=3

# InfluxDB Disk Size
INFLUX_DISK=25GB

# Chronograf and Kapacitor Disk Sizes
OTHER_DISK=10GB
