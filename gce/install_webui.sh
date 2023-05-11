#!/bin/bash

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
  aria2 \
  emacs \
  git \
  libgl1 \
  libglib2.0-0 \
  python-is-python3 \
  python3 \
  python3-pip \
  screen \


git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui

python -u launch.py --skip-torch-cuda-test --xformers --exit

(cd ~/.local/lib/python3.10/site-packages/torch/lib && ln -s libnvrtc-672ee683.so.11.2 libnvrtc.so)

echo "run 'python -u launch.py --xformers --no-half-vae'"
