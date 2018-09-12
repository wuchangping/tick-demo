#!/usr/bin/env bash

delete-disks () {
  echo "Deleting disks for tick..."
  gcloud compute disks delete chronograf kapacitor influxdb --zone=$ZONE
  gcloud compute disks delete influxdb-data grafana-data --zone=$ZONE
}

delete-tick () {
  kubectl delete ns tick
}

delete-tig () {
  kubectl delete ns tig
  gcloud compute disks delete influxdb-data --zone=$ZONE
  gcloud compute disks delete grafana-data --zone=$ZONE
}

delete-flink () {
  kubectl delete ns flink
}

delete-flink-standalone () {
  kubectl delete ns flink
}

delete-flink-k8s () {
  kubectl delete ns flink-k8s
}

delete-cluster () {
  gcloud container clusters delete $CLUSTER --zone=$ZONE
}

delete-usage () {
  cat <<-HERE
  $0 delete
  - delete has the following subcommands
  
    - deletes the gcloud persistent disks for this application
    $ $0 delete disks
      
    - deletes the gcloud cluster for this application
    $ $0 delete cluster
      
    - deletes the namespace and any other kube based resources for this application
    $ $0 delete tick
    
HERE
}

delete () {
  case $1 in
    flink)
      delete-flink
      ;;
    flink-standalone)
      delete-flink-standalone
      ;;
    flink-k8s)
      delete-flink-k8s
      ;;
    tick)
      delete-tick
      ;;
    tig)
      delete-tig
      ;;
    cluster)
      delete-cluster
      ;;
    disks)
      delete-disks
      ;;
    *)
      echo "USAGE: $0 $1"
      delete-usage
      exit 1
      ;;
  esac
}
