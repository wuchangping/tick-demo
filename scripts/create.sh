#!/usr/bin/env bash

kube () {
  kubectl apply -f $1
}

create-cluster () {
  echo "Creating a $NUM_NODES node cluster of $MACHINE VMs with $DISK GB size disks."
  gcloud container clusters create --disk-size $DISK --machine-type $MACHINE --num-nodes $NUM_NODES $CLUSTER 
  gcloud container clusters get-credentials $CLUSTER
}

create-disks () {
  echo "Creating persistent disks for the tick stack..."
  echo "InfluxDB Disk: $INFLUX_DISK"
  echo "Kapacitor Disk: $OTHER_DISK"
  echo "chronograf Disk: $OTHER_DISK"
  gcloud compute disks create chronograf kapacitor --size=$OTHER_DISK
  gcloud compute disks create influxdb --size=$INFLUX_DISK
}

create-flink () {
  echo "Creating flink..."
  kube $BP/flink/namespace.yaml
  kube $BP/flink/flink-service.yaml
  kube $BP/flink/jobmanager-deployment.yaml
  kube $BP/flink/taskmanager-deployment.yaml

  echo "kubectl get svc --namespace flink  "
  kubectl get svc --namespace flink  
}

create-tick () {
  echo "Creating tick..."
  echo "tick is the full stack of InfluxData products running in production configuration"
  kube $BP/namespace.yaml
  kubectl create configmap --namespace tick telegraf-config --from-file $BP/telegraf/telegraf.conf
  kubectl create configmap --namespace tick influxdb-config --from-file $BP/influxdb/influxdb.conf
  kube $BP/influxdb/deployment.yaml
  kube $BP/influxdb/service.yaml
  kube $BP/kapacitor/deployment.yaml
  kube $BP/kapacitor/service.yaml
  kube $BP/telegraf/daemonset.yaml
  kube $BP/chronograf/deployment.yaml
  kube $BP/chronograf/service.yaml
  echo "Waiting for public IP..."
  echo "kubectl get svc --namespace tick "
  kubectl get svc --namespace tick  
}

create-usage () {
  cat <<-HERE 
  $0 create
  - create has the following subcommands
  
    - creates cluster to run this example
    $ $0 create cluster
    
    - creates all gcloud persistent disks for this application 
    $ $0 create disks
  
    - creates all kube based resources for this application 
    $ $0 create tick
    
HERE
}

create () {
  case $1 in
    flink)
      create-flink
      ;;
    tick)
      create-tick
      ;;
    cluster)
      create-cluster
      ;;
    disks)
      create-disks
      ;;
    *)
      echo "USAGE: $0 $1"
      create-usage
      exit 1
      ;;
  esac
}

