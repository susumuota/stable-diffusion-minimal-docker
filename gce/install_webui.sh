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

cat >> config.json <<EOF
{
    "grid_save": false,
    "grid_save_to_dirs": false,
    "return_grid": false,
    "js_modal_lightbox_initially_zoomed": false,
    "live_previews_enable": false,
    "show_progress_grid": false
}
EOF

echo "run 'python -u launch.py --xformers --no-half-vae'"
