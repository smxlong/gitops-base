#!/bin/bash

set -e

GITOPS_REPO=git@github.com:smxlong/gitops-base.git

cd $(dirname $0)

helm3 repo add fluxcd https://charts.fluxcd.io
helm3 repo update

kubectl create namespace flux-base || true

helm3 upgrade -i flux fluxcd/flux \
  --set git.url=$GITOPS_REPO \
  --set git.path=cluster \
  --set git.label=flux-sync-$(openssl rand -hex 6) \
  --set git.pollInterval=15s \
  --set sync.interval=15s \
  --set sync.state=secret \
  --set syncGarbageCollection.enabled=true \
  --namespace flux-base
