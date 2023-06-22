#!/bin/bash

# create a bucket before running this script
# gsutil mb -l us-central1 gs://sd-outputs-1

src="gs://sd-outputs-1/outputs"  # edit here
dst="outputs"
wait=60

mkdir -p "$dst"
while true ; do gsutil -m rsync -r "$src" "$dst" ; sleep $wait ; done
