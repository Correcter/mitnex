#!/usr/bin/env bash

docker run --rm --privileged -ti alpine /bin/sh -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled && echo never > /sys/kernel/mm/transparent_hugepage/defrag"
