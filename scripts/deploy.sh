#!/usr/bin/env bash

deploy () {
  case $1 in 
    start)
      config set
      sleep 1
      create cluster
      sleep 2
      create disks
      sleep 2
      create flink-1
      sleep 2
      create tick
      exit 0
      ;;
    shutdown)
      delete flink-1
      delete tick
      delete cluster
      delete disks
      exit 0
      ;;
    *)
      echo "USAGE: $0 $1"
      deploy-usage
      exit 1
      ;;
  esac
}

deploy-usage () {
  cat <<-HERE
  $0 deploy
  - deploy has the following subcommands
  
    - deploy start a new cluster w/ all resources and provisions the full tick stack
    $ $0 deploy start

    - deletes the cluster and all associated resources
    $ $0 deploy shutdown
    
HERE
}
