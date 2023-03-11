#!/bin/sh

k8s_img=$1
mirror_img=$(echo ${k8s_img} | sed 's/quay\.io/wuyingbo\/quay/g;s/ghcr\.io/wuyingbo\/ghcr/g;s/registry\.k8s\.io/wuyingbo\/google-containers/g;s/k8s\.gcr\.io/wuyingbo\/google-containers/g;s/gcr\.io/wuyingbo/g;s/\//\./g;s/ /\n/g;s/wuyingbo\./wuyingbo\//g' | uniq)

if [ -x "$(command -v docker)" ]; then
  sudo docker pull ${mirror_img}
  sudo docker tag ${mirror_img} ${k8s_img}
  exit 0
fi

if [ -x "$(command -v ctr)" ]; then
  sudo ctr -n k8s.io image pull docker.io/${mirror_img}
  sudo ctr -n k8s.io image tag docker.io/${mirror_img} ${k8s_img}
  exit 0
fi

echo "command not found:docker or ctr"
