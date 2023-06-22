#!/bin/bash

# create a bucket before running this script
# gsutil mb -l us-central1 gs://sd-outputs-1

src="outputs"
dst="gs://sd-outputs-1/outputs"  # edit here
wait=60

# cd stable-diffusion-webui
mkdir -p "$src"
while true ; do gsutil -m rsync -r "$src" "$dst" ; sleep $wait ; done
