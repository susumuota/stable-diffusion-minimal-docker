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

sed -i -e "/pip install torch/ s/cu[0-9]\{3,\}/cpu/g" launch.py
sed -i -e 's/    return "cpu"/    torch.set_num_threads(4)\n    return "cpu"/' modules/devices.py

python -u launch.py --skip-torch-cuda-test --exit

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

echo "run 'python -u launch.py --skip-torch-cuda-test --use-cpu=all --no-half --no-half-vae'"
