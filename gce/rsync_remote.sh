#!/bin/bash

src="outputs"
dst="gs://sd-outputs-1/outputs"
wait=60

# cd stable-diffusion-webui
mkdir -p "$src"
while true ; do gsutil -m rsync -r "$src" "$dst" ; sleep $wait ; done
