#!/bin/bash

src="gs://sd-outputs-2/outputs"
dst="outputs"
sleep_seconds=60

# mkdir -p outputs
while true ; do gsutil -m rsync -r "$src" "$dst" ; sleep $sleep_seconds ; done
