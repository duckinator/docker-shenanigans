#!/usr/bin/env bash

# Stop on first error
set -e

REPONAME="docker-shenanigans-xorg"
TAG="latest"
MOUNTS="-v /tmp/.X11-unix/:/tmp/.X11-unix/:rw -w /home/ubuntu"

image=$(docker images --format "{{.Repository}}\t{{.Tag}}\t{{.CreatedAt}}" "${REPONAME}:${TAG}")

REBUILD=false
if [ -z "${image}" ]; then
  echo "(INFO) ${REPONAME} Docker image not found, building..."
  REBUILD=true
fi

if [ "$1" == "--delete" ]; then
  echo "(INFO) Removing Docker image."
  shift
  [ -n "${image}" ] && docker rmi "${REPONAME}"
fi

if [ "$1" == "--rebuild" ]; then
  echo "(INFO) Rebuilding ${REPONAME} Docker image."
  REBUILD=true
  shift
fi

if $REBUILD; then
    docker build . -t "${REPONAME}"
fi

# Enable "non-network local connections" to Xorg.
# I think this means anything with access to the unix socket?
xhost +local:

docker run --rm -it ${MOUNTS} ${XAUTH_MOUNTS} -u $(id -u) -e DISPLAY="unix${DISPLAY}" "${REPONAME}" "$@"

# Revert changes above.
xhost -local:
