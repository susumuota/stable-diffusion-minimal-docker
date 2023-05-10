#!/bin/bash

src="outputs"
dst="gs://sd-outputs-2/outputs"
sleep_seconds=60

# cd stable-diffusion-webui
while true ; do gsutil -m rsync -r "$src" "$dst" ; sleep $sleep_seconds ; done
