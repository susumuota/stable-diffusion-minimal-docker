#!/bin/bash

src="gs://sd-outputs-1/outputs"
dst="outputs"
wait=60

mkdir -p "$dst"
while true ; do gsutil -m rsync -r "$src" "$dst" ; sleep $wait ; done
