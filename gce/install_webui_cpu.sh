#!/bin/bash

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
  aria2 \
  git \
  libgl1 \
  libglib2.0-0 \
  python-is-python3 \
  python3 \
  python3-pip \
  python3-venv \


git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui

TORCH_INDEX_URL="https://download.pytorch.org/whl/cpu" ./webui.sh --skip-torch-cuda-test --exit

sed -i -e 's/    return "cpu"/    torch.set_num_threads(8)\n    return "cpu"/' modules/devices.py

cat >> config.json <<EOF
{
    "export_for_4chan": false,
    "grid_save": false,
    "grid_save_to_dirs": false,
    "return_grid": false,
    "js_modal_lightbox_initially_zoomed": false,
    "live_previews_enable": false,
    "show_progress_grid": false,
    "CLIP_stop_at_last_layers": 2
}
EOF

echo "./webui.sh --skip-torch-cuda-test --use-cpu=all --no-half --no-half-vae"
